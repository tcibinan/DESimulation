function y = regression(a, x1, x2, x3)
  a0 = a(1);
  a1 = a(2);
  a2 = a(3);
  a3 = a(4);
  a12 = a(5);
  a13 = a(6);
  a23 = a(7);
  a123 = a(8);
  y = a0 + a1*x1 + a2*x2 + a3*x3 + a12*x1*x2 + a13*x1*x3 + a23*x2*x3 +a123*x1*x2*x3;
end
