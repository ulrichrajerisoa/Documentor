Class {
	#name : 'DocumentorLinter',
	#superclass : 'Object',
	#category : 'Documentor',
	#package : 'Documentor'
}

{ #category : 'analyzing' }
DocumentorLinter >> cyclomaticComplexityOfMethod: aCompiledMethod [
	| complexity conditionalSelectors |
	conditionalSelectors := #(ifTrue: ifFalse: ifTrue:ifFalse: ifFalse:ifTrue: whileTrue: whileFalse: whileTrue whileFalse).
	complexity := 1.
	aCompiledMethod ast nodesDo: [ :node |
		(node isMessage and: [ conditionalSelectors includes: node selector ])
			ifTrue: [ complexity := complexity + 1 ] ].
	^ complexity
]

{ #category : 'analyzing' }
DocumentorLinter >> methodsWithoutDirectInstVarAccess: aClass [
	| instVars |
	instVars := aClass instVarNames asSet.
	^ aClass methods select: [ :method |
		| accessesInstVar |
		accessesInstVar := false.
		method ast nodesDo: [ :node |
			(node isVariable and: [ instVars includes: node name ])
				ifTrue: [ accessesInstVar := true ] ].
		accessesInstVar not ]
]

{ #category : 'analyzing' }
DocumentorLinter >> methodsWithoutSelfOrInstVarAccess: aClass [
	| instVars |
	instVars := aClass instVarNames asSet.
	^ aClass methods select: [ :method |
		| accessesSelfOrInstVar |
		accessesSelfOrInstVar := false.
		method ast nodesDo: [ :node |
			(node isVariable and: [ node name = 'self' or: [ instVars includes: node name ] ])
				ifTrue: [ accessesSelfOrInstVar := true ] ].
		accessesSelfOrInstVar not ]
]

{ #category : 'analyzing' }
DocumentorLinter >> totalCyclomaticComplexityOf: aClass [
	^ aClass methods sum: [ :each | self cyclomaticComplexityOfMethod: each ]
]
