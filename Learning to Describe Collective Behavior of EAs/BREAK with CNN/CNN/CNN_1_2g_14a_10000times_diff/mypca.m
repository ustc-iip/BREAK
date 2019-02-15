function [ data_reduction,V,D ] = mypca( data,k )
% ����������ֻ��X���򷵻�90%��ά��Ľ���������������ά��ָ����
if nargin<2
    k=0;
end
[rows,cols]=size(data);
COV=cov(data);
COV=double(COV);
if k>1
   [V,D]=eigs(COV,k);
else
    d=eigs(COV);
    d=sort(d,'descend');
    for k=1:cols
        if sum(d(1:k))/sum(d)>0.95
            break;
        end
    end
    [V,D]=eigs(COV,k);
end
m=mean(data);
data=data-repmat(m,rows,1);
data_reduction=data*V;
end

mean(data);
data=data-repmat(m,rows,1);
data_reduction=data*V;
data_reduction=data_reduction(:,k:-1:1);
end



