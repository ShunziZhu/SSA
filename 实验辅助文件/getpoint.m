function y=getpoint(data,start,num)%ѡ��ֵ��,��ѡȡstart���start��+1�����������Ҹ�ѡ�߸�����16���㣬numΪȱʧ�����
    y=[data(start);data(start+1)];
    for i=1:7
        y=[data(start-i*(num+1));y;data(start+1+i*(num+1))];
    end
end