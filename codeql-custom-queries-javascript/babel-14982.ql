import javascript
import semmle.javascript.dataflow.InferredTypes

predicate syntacticTemplate(ObjectPattern objPattern) {
  objPattern.getNumProperty() = 0 and
  exists(Expr e | e = objPattern.getRest())
}

private predicate isNullorUndefined(InferredType t) { t = TTNull() or t = TTUndefined() }

predicate semanticTemplate(ObjectPattern objPattern) {
  isNullorUndefined(objPattern.flow().analyze().getAType())
}

from ObjectPattern objPattern
where
  syntacticTemplate(objPattern) and
  semanticTemplate(objPattern) and
  not objPattern.flow().analyze().getAValue().isIndefinite(_) // !debug
select objPattern, "Detected babel issue #14982", objPattern.flow().analyze().getAValue()
