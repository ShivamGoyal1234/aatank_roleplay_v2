import Big from 'big.js';
export default function operate(a,b,op){
  const x=Big(a||'0');
  const y=Big(b||'0');
  if(op==='+' )return x.plus(y).toString();
  if(op==='-')return x.minus(y).toString();
  if(op==='x'||op==='×'||op==='*')return x.times(y).toString();
  if(op==='÷'||op==='/')return y.eq(0)?'Error':x.div(y).toString();
  if(op==='%')return x.mod(y).toString();
  return '0';
}
