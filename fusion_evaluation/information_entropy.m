function entropyR=information_entropy(grey_matrix,grey_level)
% compute the shannon information entropy of the image

[row,column]=size(grey_matrix);
total=row*column;
% grey_level=256 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
counter=zeros(1,grey_level);
grey_matrix=grey_matrix+1;
for i=1:row
    for j=1:column
        indexx=grey_matrix(i,j);
        counter(indexx)=counter(indexx)+1;
    end
end
total=sum(counter(:));
index=find(counter~=0);
p=counter/total;
entropyR=sum(sum(-p(index).*log2(p(index))));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%