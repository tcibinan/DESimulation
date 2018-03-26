function I = economic(En, c1, c2, c3, c4, c5, T, s, Ma, Ns, Nq, Ca)
  I = En*c1*s + c2*(Ns-Nq) + c3*(s-Ns+Nq) + c4*T*((Ma^-1)-Ca) + c5*T*Nq;
end
