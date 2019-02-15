function [ data_reduction,V,D ] = mypca_2( data,k )
  [V,data_reduction,D]=pca(data,'Algorithm','eig','NumComponents',k);
end