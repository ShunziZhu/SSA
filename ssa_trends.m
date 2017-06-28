function [y,trends,per,sigma2]=ssa_trends(x,L)%yΪ�ع��źţ�
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
    lam=sigma2.^2;
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
            elseif k>=L2 && k<=K2
                for q=1:L2
                    y(k,i)=y(k,i)+Z(q,k-q+1); 
                end
                y(k,i)=y(k,i)/L2;
            elseif k>=K2 && k<=N
                for q=(k-K2+1):(N-K2+1)
                    y(k,i)=y(k,i)+Z(q,k-q+1);
                end
                y(k,i)=y(k,i)/(N-k+1);
            end
        end
    end
%��������ȡ
    trends=0;
    n=1;
    for m=1:length(sigma2)
        Kr=0;
        for i=1:(N-1)
            for j=i+1:N
                if sign(y(j,m)-y(i,m))==-1
                    Kr=Kr+sign(y(j,m)-y(i,m))+1;
                else
                    Kr=Kr+sign(y(j,m)-y(i,m));
                end
           
            end
        end
        t=-1+4*Kr/(N*(N-1));
        s=sqrt(2*(2*N+5)/(9*N*(N-1)));
        if t>1.96*s || t<-1.96*s
            trends(n)=m;
            n=n+1;
        end
    end
    slam=sum(lam);
    per=0;
    n=1;
    for i=1:length(trends)
        per(n)=lam(trends(i))/slam;
        n=n+1;
    end
    
    z=zeros(length(x),1);
    for i=1:length(trends)
        z=z+y(:,trends(i));
    end
    m=1:length(x);
    figure(1);
    plot(m,x,'b',m,z,'r');
    grid on
    ylabel('ԭʼ�źţ���ɫ���������źţ���ɫ��');
    figure(2);
    for i=1:length(trends)
        subplot(length(trends),1,i);
        plot(y(:,trends(i)));
        grid on
        ylabel(trends(i));
    end
    
    
end