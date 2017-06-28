function [y,lam,p,per,ffk,ffk1]=ssa_period(x,L)%yΪ�ع��źţ�sigma2����ֵ��pΪ�����ffkƵ��(��Ϊ�ж�����ֵ�Ƿ�ӽ�)��perΪ������
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


%�����ж�
    m_i=sqrt(-1);
    ffk=0;
    ffk1=0;
    p=0;
    n=1;
    for k=1:length(sigma2)-1
        Ek=0;
        Ek1=0;
        fk=0;
        fk1=0;
        for f=0:0.001:0.5
            Ekt=0;
            Ek1t=0;
            for j=1:length(sigma2)
                Ekt=Ekt+U(j,k)*exp(m_i*2*pi*j*f);%UΪ�����к��о�Ϊlength(sigma2)
                Ek1t=Ek1t+U(j,k+1)*exp(m_i*2*pi*j*f);
            end
            if (abs(Ekt)*abs(Ekt))>(abs(Ek)*abs(Ek))%������ģ��ƽ���������ڸ�����ƽ��
                Ek=Ekt;
                fk=f;
            end
            if (abs(Ek1t)*abs(Ek1t))>(abs(Ek1)*abs(Ek1))
                Ek1=Ek1t;
                fk1=f;
            end
        end
        cri1=2*length(sigma2)*abs(fk-fk1);
        cri2=((abs(Ek)*abs(Ek))+(abs(Ek1)*abs(Ek1)))/length(sigma2);
        if cri1<0.75 && cri2>(2/3)
            p(n)=k;
            ffk(n)=fk;
            ffk1(n)=fk1;
            n=n+1;
        end
    end
    
    %���Ĳ����ع�
    y=zeros(N,length(sigma2));
	L2=min(L,K);
	K2=max(L,K);
    for i=1:length(sigma2)
        Z=sigma2(i)*U(:,t(i))*V(:,t(i))';
        for k=1:N
            if k>=1 && k<=L2
            for q=1:k
                  y(k,i)=y(k,i)+Z(q,k-q+1); 
            end
            y(k,i)=y(k,i)/k;
            end
            if k>=L2 && k<=K2
            for q=1:L2
                y(k,i)=y(k,i)+Z(q,k-q+1); 
            end
            y(k,i)=y(k,i)/L2;
            end
            if k>=K2 && k<=N
                for q=(k-K2+1):(N-K2+1)
                    y(k,i)=y(k,i)+Z(q,k-q+1);
                end
                y(k,i)=y(k,i)/(N-k+1);
            end
        end
    end
    lam=sigma2.^2;
    slam=sum(lam);
    per=0;
    n=1;
    for i=1:length(p)
        per(n)=(lam(p(i))+lam((p(i)+1)))/slam;%perΪ������
        n=n+1;
    end
end