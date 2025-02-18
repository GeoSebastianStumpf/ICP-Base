%get DwellTimes function
%filepath = "D:\OneDrive - Universitaet Bern\PhD\Project LARP\Test Data\Mineral Analysis\Alm06_Min\AcqMethod.xml";

function result = get_agilent_acqmethod_dwelltimes(filepath)

% Read the XML file
xmlData = xmlread(filepath);

% Get all IcpmsElement nodes
elements = xmlData.getElementsByTagName('IcpmsElement');

% Initialize arrays to store element names and integration times
elementNames = cell(1, elements.getLength);
integrationTimes = zeros(1, elements.getLength);

% Loop through each IcpmsElement node
for i = 0:elements.getLength-1
    % Get the current IcpmsElement node
    element = elements.item(i);

    % Get the ElementName, IntegrationTime, and MZ nodes
    elementNameNode = element.getElementsByTagName('ElementName').item(0);
    integrationTimeNode = element.getElementsByTagName('IntegrationTime').item(0);
    mzNode = element.getElementsByTagName('MZ').item(0);

    % Extract the text content of the nodes
    elementName = char(elementNameNode.getTextContent());
    integrationTime = str2double(char(integrationTimeNode.getTextContent()));
    mzValue = str2double(char(mzNode.getTextContent()));

    % Combine element names with MZ values
    elementNames{i+1} = [elementName, num2str(mzValue)];
    integrationTimes(i+1) = integrationTime;
end

% Create a table with integration times as values and element names as column headers
result = array2table(integrationTimes, 'VariableNames', elementNames);

end