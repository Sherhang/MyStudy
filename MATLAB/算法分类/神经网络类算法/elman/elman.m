clear;
clc;
Z_n=10*rand(6,366);
Z_n(7,:)=10*sin(Z_n(1,:));
%% ����������
% ���ݸ���
% n=length(Z_n);
% 
% % ȷ��ZΪ������
%  Z_n=Z_n(:);
% 
% % Z(n) ��Z(n-1),Z(n-2),...,Z(n-L)��L����Ԥ��õ�.
% L = 6;
% 
% % Z_n��ÿ��Ϊһ��������ϵ���������n-L������
% Z_n = zeros(L+1, n-L);
% for i=1:n-L
%     Z_n(:,i) = Z_n(i:i+L);
% end


%% ����ѵ������������
% ��ǰ300�����ݻ���Ϊѵ������
% ��66�����ݻ���Ϊ��������

trainx = Z_n(1:6, 1:300);
trainy = Z_n(7, 1:300);

testx = Z_n(1:6, 301:end);
testy = Z_n(7, 301:end);


%% ����Elman������

% ����15����Ԫ��ѵ������Ϊtraingdx
net=elmannet(1:2,15,'traingdx');

% ������ʾ����
net.trainParam.show=1;

% ����������Ϊ2000��
net.trainParam.epochs=2000;

% ������ޣ��ﵽ�����Ϳ���ֹͣѵ��
net.trainParam.goal=0.00001;

% �����֤ʧ�ܴ���
net.trainParam.max_fail=5;

% ��������г�ʼ��
net=init(net);

%% ����ѵ��

%ѵ�����ݹ�һ��
[trainx1, st1] = mapminmax(trainx);
[trainy1, st2] = mapminmax(trainy);

% ������������ѵ��������ͬ�Ĺ�һ������
testx1 = mapminmax('apply',testx,st1);
testy1 = mapminmax('apply',testy,st2);

% ����ѵ����������ѵ��
[net,per] = train(net,trainx1,trainy1);

%% ���ԡ������һ��������ݣ��ٶ�ʵ��������з���һ��

% ��ѵ����������������в���
train_ty1 = sim(net, trainx1);
train_ty = mapminmax('reverse', train_ty1, st2);

% ��������������������в���
test_ty1 = sim(net, testx1);
test_ty = mapminmax('reverse', test_ty1, st2);

%% ��ʾ���
% ��ʾѵ�����ݵĲ��Խ��
figure(1)
x=1:length(train_ty);

% ��ʾ��ʵֵ
plot(x,trainy,'b-');
hold on
% ��ʾ����������ֵ
plot(x,train_ty,'r--')

legend('С����ʵֵ','Elman�������ֵ')
title('ѵ�����ݵĲ��Խ��');

% ��ʾ�в�
figure(2)
plot(x, train_ty - trainy)
title('ѵ�����ݲ��Խ���Ĳв�')

% ��ʾ�������
mse1 = mse(train_ty - trainy);
fprintf('    mse_train = \n     %f\n', mse1)

% ��ʾ������
disp('    ѵ�����������')
fprintf('%f  ', (train_ty - trainy)./trainy );
fprintf('\n')

figure(3)
x=1:length(test_ty);

% ��ʾ��ʵֵ
plot(x,testy,'b-');
hold on
% ��ʾ����������ֵ
plot(x,test_ty,'r--')

legend('С����ʵֵ','Elman�������ֵ')
title('�������ݵĲ��Խ��');

% ��ʾ�в�
figure(4)
plot(x, test_ty - testy)
title('�������ݲ��Խ���Ĳв�')

% ��ʾ�������

mse2 = mse(test_ty - testy);
fprintf('    mse_test = \n     %f\n', mse2)
% ��ʾ������
disp('    �������������')
fprintf('%f  ', (test_ty - testy)./testy );
fprintf('\n')

% ����������
test_re = test_ty - testy;
train_re = train_ty - trainy;

test_error = (test_ty - testy)./testy;
train_error = (train_ty - trainy)./trainy;