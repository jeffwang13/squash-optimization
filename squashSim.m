% Hayes Lee 20621556
% Justin Schaper 20634363
% Jeffrey Wang 20617964
% Jessie Won 20608181
% SYDE 411 - Project
% Brute force method

% Inputs
% robotX - x position of robot (m)
% robotY - y position of robot (m)
% opponentX - x position of opponent (m)
% opponentY - y position of opponent (m)
% hitVelocity - velocity of hit (m/s)

% To Implement: Elasticity, Optimization Function

% Outputs
% optimalHitAngle - best hit angle (deg)
% landTime - time the ball lands (s)
% landBallX - x position of the ball after it lands (m)
% landBallY - y position of the ball after it lands (m)

function [ optimalHitAngleV, optimalHitAngleH, bestMetric, ballX, ballY ] = squashSim()
    % For now, 0 <= vertical hit angle <= 25.11, -18.17 <= horizontal <=
    % 18.17
    tic
    i = 1;
    graphData = [];
    hitZ = 0.482; % m
    runningSpeed = 6; % m/s
    hitVelocity = 40.0; % m/s
    robotX = 9.25; % m
    robotY = 3.2; % m
    opponentX = 8.75; % m
    opponentY = 3.2; % m
    cor = 0.434; % coeficcient of restitution
    
    bestMetric = 0;
    optimalHitAngleV = 0;
    optimalHitAngleH = 0;
    ballX = 0;
    ballY = 0;
    
    i = 2;
    for theta_v = 0 : 0.01 :25.11
        j = 2;
        graphData(i, 1) = theta_v;
        
        for theta_h = -18.17 : 0.01 : 18.17
            hitVZ = hitVelocity *sind(theta_v);
            tHitGround = max(roots([4.905 -hitVZ hitZ]));
            if isreal(tHitGround) == 0
                continue;
            end
            reboundVelocity = hitVelocity * cor;
    
            % Calculate d2y including elasticity and one wall bounce
            if theta_h >= 9.32
                tHitSideWall = (6.4 - robotY) / (hitVelocity * cosd(theta_v) * sind(theta_h));
                d2y = 6.4 + reboundVelocity * cosd(theta_v) * sind(theta_h) * (tHitGround - tHitSideWall);
            elseif theta_h < -9.32
                tHitSideWall = (robotY) / (hitVelocity * cosd(theta_v) * sind(theta_h));
                d2y = 0 - (reboundVelocity * cosd(theta_v) * sind(theta_h) * (tHitGround - tHitSideWall));
            else
                d2y = robotY + hitVelocity * cosd(theta_v) * sind(theta_h) * tHitGround;
            end
    
            if d2y < 0
                d2y = -d2y;
            elseif d2y > 6.4
                d2y = 6.4 - (d2y - 6.4);
            end
    
            if d2y < 0
                d2y = 0;
            elseif d2y > 6.4
                d2y = 6.4;
            end

            % Calculate d2y including elasticity and one wall bounce
            tHitFrontWall = robotX / (hitVelocity * cosd(theta_v) * cosd(theta_h));
            d2x = reboundVelocity * cosd(theta_v) * cosd(theta_h) * (tHitGround - tHitFrontWall);
            if d2x > 9.75
                d2x = 9.75;
            end
        
            dOpponentFromBall = sqrt((d2x - opponentX).^2 + (d2y - opponentY).^2);
    
            % Result is the time it takes for the opponent to get to the ball after
            % it lands (s)
            playerTime = (dOpponentFromBall / runningSpeed);
            timeDiff = playerTime - tHitGround;
            
            graphData(1, j) = theta_h;
            graphData(i, j) = timeDiff;
            j = j + 1;
            
            if timeDiff > bestMetric
                optimalHitAngleV = theta_v;
                optimalHitAngleH = theta_h;
                bestMetric = timeDiff;
                ballX = d2x;
                ballY = d2y;
            end
        end
        i = i + 1;
    end
    
    theta_vs = graphData(1,2:end);                % first row (except first element)
    theta_hs = graphData(2:end,1);                % first column (except first element)
    times = graphData(2:end,2:end);         % actual data in the table
    surf(theta_vs,theta_hs,times)  

    disp("Results:");
    disp(optimalHitAngleV);
    disp(optimalHitAngleH);
    disp(bestMetric);
    disp(ballX);
    disp(ballY);
    toc
end
