function [ path ] =TSPpath_decode( path0 )
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%  ·����1��ʼ��
[~,num]=size(path0)
[~,p1]=find(path0==1);
path([1:num-p1+1])=path0([p1:num]);
path([num-p1+2:num])=path0([1:p1-1]);
  if path(2)>path(num);
    temp1=path(2:num);
    temp1=fliplr(temp1);%����
    path(2:num)=temp1;
  end
end

