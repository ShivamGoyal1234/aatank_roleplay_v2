import operate from './operate';
export default function calculate({ total,next,operation },buttonName){
  if(buttonName==='C')return{ total:'0',next:null,operation:null };
  if(['+','-','x','÷','*','/','%'].includes(buttonName)){
    if(next)return{ total:next,next:null,operation:buttonName };
    return{ operation:buttonName };
  }
  if(buttonName==='='){
    if(next&&operation){
      const result=operate(total,next,operation);
      return{ total:result,next:null,operation:null };
    }
    return{};
  }
  if(buttonName==='.'){
    if(next){
      if(!next.includes('.'))return{ next:next+'.' };
      return{};
    }
    return{ next:'0.' };
  }
  return next?{ next:next+buttonName }:{ next:buttonName };
}
