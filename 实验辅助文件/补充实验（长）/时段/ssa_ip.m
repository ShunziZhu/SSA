function y=ssa_ip(x,L,p)%yΪ�ع��źţ��ڲ岹ȱʧ����ʱ�õ���ssa
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
end