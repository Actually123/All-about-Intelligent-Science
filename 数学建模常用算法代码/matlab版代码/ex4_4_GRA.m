Mean = mean(gdp);  % ���ÿһ�еľ�ֵ�Թ�����������Ԥ����
gdp = gdp ./ repmat(Mean,size(gdp,1),1);  %size(gdp,1)=6, repmat(Mean,6,1)���Խ�������и��ƣ�����Ϊ��gdpͬ�ȴ�С��Ȼ��ʹ�õ������ӦԪ�����������Щ�ڵ�һ����η�����������
disp('Ԥ�����ľ���Ϊ��'); disp(gdp)

Y = gdp(:,1);  % ĸ����
X = gdp(:,2:end); % ������
absX0_Xi = abs(X - repmat(Y,1,size(X,2)))  % ����|X0-Xi|����(���������ǰ�X0����Ϊ��Y)
a = min(min(absX0_Xi))    % ����������С��a
b = max(max(absX0_Xi))  % ������������b
rho = 0.5; % �ֱ�ϵ��ȡ0.5
gamma = (a+rho*b) ./ (absX0_Xi  + rho*b)
disp('�������и���ָ��Ļ�ɫ�����ȷֱ�Ϊ��');
disp(mean(gamma))
