
function[Best_score,Best_pos,HLBO_curve]=HLBO(SearchAgents,Max_iterations,lowerbound,upperbound,dimension,fitness)

lowerbound=ones(1,dimension).*(lowerbound);                              % Lower limit for variables
upperbound=ones(1,dimension).*(upperbound);                              % Upper limit for variables

%%
for i=1:dimension
    X(:,i) = lowerbound(i)+rand(SearchAgents,1).*(upperbound(i) - lowerbound(i));                   % Initial population
end

for i =1:SearchAgents
    L=X(i,:);
    fit(i)=fitness(L);
end
%%

for t=1:Max_iterations
    %% update the best member
    [best , blocation]=min(fit);
    [fworst , ~]=max(fit);

    %% Phase 1: Exploration phase
    % candidate solution
    for i=1:SearchAgents
    Q(i,:)=fit-fworst/fit(i)-fworst;              %eqn(4)
    end

    if t==1
        Xbest=X(blocation,:);                                          % Optimal location
        Qbest=Q(blocation,:);
        fbest=best;                                               % The optimization objective function
        
    elseif best<fbest 
        fbest=best;
        Xbest=X(blocation,:);
        Qbest=Q(blocation,:);
    end
    k=randperm(SearchAgents);
for i=1:SearchAgents
    for j=1:dimension


    PCi=Q(i)/Q(i)+Qbest+Q(k(i));              %eqn 5.
    PCbest=Qbest/Q(i)+Qbest+Q(k(i));
    PCk=Q(k(i))/Q(i)+Qbest+Q(k(i));
    Xk(i,j)=X(k(i),j);
    

    HL(i,j)=PCi(i).*X(i,j)+PCbest(i).*Xbest(:,j)+PCk(i).*Xk(i,j) ;          %eqn.6


    end
end
    %%
    XF=[X fit'];
    XFsort=sort(XF);
    X=XFsort(:,1:dimension);
    fit=(XFsort(:,1+dimension) )';
    XFsort=fit;
    F_DI=XFsort;
    
    %% update HLBO population
    
    for i=1:SearchAgents
        
        %% Phase 1: Exploration (global search)
        k_i=randperm(SearchAgents,1);
        %DI_ki=DI(k_i);
        F_HL_ki=F_DI(k_i);
        I=round(1+rand(1,1));
        if F_HL_ki< fit (i)
            X_P1=X(i,:)+rand(1,1) .* (HL(i,:)-I.*X(i,:)); % Eq. (7)
        else
            X_P1=X(i,:)+rand(1,1) .* (1.*X(i,:)-I.*HL(i,:)); 
        end
        
        % Update X_i based on Eq(8)
        F_P1 = fitness(X_P1);
        if F_P1 <= fit (i)
            X(i,:) = X_P1;
            fit (i)=F_P1;

        end
        
        %% END Phase 1:  (exploration)

       
        
        %% Phase 2: Exploitation (local search)
        R=0.05;
        X_P3= X(i,:)+ (1-2*rand(1,dimension))*R*(1-t/Max_iterations).*X(i,:);% Eq.(9)
        
        % Update X_i based on Eq(10)
        F_P3 = fitness(X_P3);
        if F_P3 <= fit (i)
            X(i,:) = X_P3;
            fit (i)=F_P3;
        end
        %% END Phase of exploitation
        
    end% END for i=1:SearchAgents
    
    best_so_far(t)=fbest;
    
end% END for t=1:Max_iterations
Best_score=fbest;
Best_pos=Xbest;
HLBO_curve=best_so_far;
end

