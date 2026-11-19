Class {
	#name : 'Documentor',
	#superclass : 'Object',
	#instVars : [
		'builder'
	],
	#category : 'Documentor',
	#package : 'Documentor'
}

{ #category : 'as yet unclassified' }
Documentor >> documentClass: aClass [
	builder
		header: [ builder text: aClass name ] withLevel: 1;
		paragraph: [ builder text: (aClass comment ifEmpty: [ 'No class comment.' ]) ].
	self
		documentInstanceVariablesOf: aClass;
		documentMethodsOf: aClass.
	^ builder contents
]

{ #category : 'as yet unclassified' }
Documentor >> documentInstanceVariablesOf: aClass [
	builder header: [ builder text: 'Instance Variables' ] withLevel: 2.
	aClass instVarNames
		ifEmpty: [ builder paragraph: [ builder text: 'None.' ] ]
		ifNotEmpty: [ :vars |
			builder unorderedListDuring: [
				vars do: [ :each |
					builder item: [ builder monospace: each ] ] ] ]
]

{ #category : 'as yet unclassified' }
Documentor >> documentMethodsOf: aClass [
	builder header: [ builder text: 'Methods' ] withLevel: 2.
	aClass selectors
		ifEmpty: [ builder paragraph: [ builder text: 'None.' ] ]
		ifNotEmpty: [ :selectors |
			builder unorderedListDuring: [
				selectors sorted do: [ :each |
					builder item: [ builder monospace: each ] ] ] ]
]

{ #category : 'initialization' }
Documentor >> initialize [
	super initialize.
	builder := MicMicrodownTextualBuilder new
]
