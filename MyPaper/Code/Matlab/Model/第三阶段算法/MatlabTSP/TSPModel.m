classdef TSPModel
    properties
        N ; % ��������
        P ; % ����λ��
        MatrixP;  % ���еľ������
    end
    methods
        function obj = TSPModel(numOfCity, p)
            obj.N = numOfCity;
            if nargin < 2
                obj.P = 100*1000*rand(numOfCity,2);
            else
                obj.P = p;
            end

            % ����������
           obj.MatrixP = inf*ones(obj.N, obj.N);
            for i=1:obj.N
                for j=1:obj.N
                    if i~=j
                        obj.MatrixP(i,j) = sqrt((obj.P(i,1)-obj.P(j,1))^2+(obj.P(i,2)-obj.P(j,2))^2);
                    end
                end
            end
        end
        
    end
end