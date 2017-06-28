function [y,r,p]=my_ssa_pure(x,L)%yΪ�ع��źţ�rΪ�в�
%xΪʱ�����У�LΪ���ڳ���
%��һ��������켣����
    N=length(x);
    K=N-L+1;
    X=zeros(L,K);
    for i=1:L
        for j=1:K
            X(i,j)=x(i+j-1);
        end
    end
%�ڶ���������ֵ�ֽ�
    [U,S,V]=svd(X);%����X��svd�ֽ�����ã�sigma��ƽ����XX'��X'X������ֵ�����Ӧ�����������ֱ���U��V��������
    sigma=diag(S);
    sigma=-sigma;
    [sigma2,t]=sort(sigma);%����
    sigma2=-sigma2;
    %d=length(sigma2);
%������������
    c2=0;%��ʼ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%��p
    for p=1:(length(sigma2)-1)%ѭ������ѵ�pֵ
        si2=sigma2(p+1:length(sigma2),:);
        si3=sigma2(p:length(sigma2),:);
        si2=[si2;si2(length(si2))];
        c=corrcoef(si2,si3);%�����ϵ��
        c2=[c2;c(2,1);];
    end
    c2(1,:)=[];
    [m_c,p]=min(c2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Z=zeros(L,K);
    for i=1:p
        Z=Z+sigma2(i)*U(:,t(i))*V(:,t(i))';
    end
%���Ĳ����ع�
    y=zeros(N,1);
	L2=min(L,K);
	K2=max(L,K);
    
    for k=1:N
        if k>=1 && k<=L2
           for q=1:k
              y(k)=y(k)+Z(q,k-q+1); 
           end
           y(k)=y(k)/k;
        end
        if k>=L2 && k<=K2
           for q=1:L2
              y(k)=y(k)+Z(q,k-q+1); 
           end
           y(k)=y(k)/L2;
        end
        if k>=K2 && k<=N
           for q=(k-K2+1):(N-K2+1)
              y(k)=y(k)+Z(q,k-q+1);
           end
           y(k)=y(k)/(N-k+1);
        end
    end
    r=x-y;
    m=1:N;
    figure(1);
    subplot(2,1,1);
    plot(m,x,'b',m,y,'g');
    grid on
    ylabel('ԭʼ�źţ���ɫ�����˲��źţ���ɫ��');
    subplot(2,1,2);
    plot(m,r,'b');
    grid on
    ylabel('�в�');

end