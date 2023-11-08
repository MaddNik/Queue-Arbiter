module RequestQueue(reset, clock, R0, R1, G0, G1);
input reset; //reset line
input clock;
input R0; //Requester 0
input R1; // Requestor 1

output G0; // Grant line 0
output G1; // Grant line 1

reg currentState, nextState;
reg G0, G1, flag; // flag bit is exclusively used for R0 R1 = 1 1 case

parameter
    s0= 0,
    s1= 1,
    s2= 2;
    
 always@(posedge clock or negedge reset)
 begin
    if(!reset)
        currentState = s0;
     else
        begin
            currentState = nextState;
        end
 end
 
 always@(currentState or R0 or R1)
 begin
 G0=1'bx;
 G1=1'bx;
 nextState=1'bx;
    casex(currentState)
        s0:
            begin
                if(R0 | R1)
                    begin
                        casex({R0, R1})
                            2'b00:
                                begin
                                    G0=1'b0;
                                    G1=1'b0;
                                    flag =1'b0;
                                    nextState = s0;
                                end
                            2'b01:
                                begin
                                    G0=1'b0;
                                    G1=1'b1;
                                    flag =1'b0;
                                    nextState = s1;
                                end
                            2'b10:
                                begin
                                    G0=1'b1;
                                    G1=1'b0;
                                    if(!flag)
                                        begin
                                            nextState = s2;
                                            flag = 1'b1;
                                        end
                                    else
                                        begin
                                            nextState = s1;
                                            flag = 1'b0;
                                        end
                                end
                            2'b11:
                                begin
                                    G0=1'b1;
                                    G1=1'b0;
                                    flag =1'b1;
                                    nextState = s2;
                                end
                            default:
                                begin
                                   G0=1'bx;
                                    G1=1'bx;
                                    flag =1'bx;
                                    nextState = 1'bx; 
                                end
                                                                 
                        endcase    
                    end
            end
        s1:
            begin
                if(flag)
                    begin
                        G0 = 1'b0;
                        G1= 1'b1;
                        flag= 1'b0;
                        nextState=s0;
                    end
                else
                    begin
                        flag=1'b0;
                        G0=1'bx;
                        G1= 1'bx;
                        nextState= s0;
                    end
            end
        s2:
            begin
                flag=1'b0;
                nextState= s0;
                G0=1'bx;
                G1= 1'bx;
            end
        default:
            begin
                flag=1'bx;
                nextState= 1'bx;
                G0=1'bx;
                G1= 1'bx;
            end
    endcase
 end
    
endmodule
