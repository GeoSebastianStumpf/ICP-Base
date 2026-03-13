

A = struct();

A.B = rand(10^4);

tic
save('test3.mat','A',"-v7.3","-nocompression")
toc

tic
save('test4.mat','A',"-v7.3")
toc

%%% asdfsdfdsf