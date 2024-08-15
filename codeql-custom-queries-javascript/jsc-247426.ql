import javascript

private predicate isClassInitializedMember(MemberDeclaration md) {
  md.isStatic() or md instanceof MethodDefinition
}

predicate syntacticTemplate(ClassDefinition cd) {
  isClassInitializedMember(cd.getAMember()) and
  exists(MemberDeclaration member | member = cd.getAMember() |
    member.getName() = cd.getVariable().getName()
  )
  or
  exists(DeclStmt decl | decl = cd.getAStaticInitializerBlock().getAStmt() |
    decl.getADecl().toString() = cd.getVariable().getName()
  )
}

predicate semanticTemplate(Locatable x) { any() }

from ClassDeclStmt cd
where syntacticTemplate(cd) and semanticTemplate(_)
select cd, "Detected JSC bug #247426"
