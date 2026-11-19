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
Documentor >> appendDocumentationForClass: aClass [
	builder
		header: [ builder text: aClass name ] withLevel: 1;
		paragraph: [ builder text: (aClass comment ifEmpty: [ 'No class comment.' ]) ].
	self
		documentInstanceVariablesOf: aClass;
		documentMethodsOf: aClass
]

{ #category : 'generating' }
Documentor >> documentClass: aClass [
	self resetBuilder.
	self appendDocumentationForClass: aClass.
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

{ #category : 'generating' }
Documentor >> documentPackageNamed: aPackageName [
	| package classes |
	package := self packageOrganizer packageNamed: aPackageName.
	classes := package definedClasses sorted: [ :a :b | a name < b name ].
	self resetBuilder.
	classes do: [ :each | self appendDocumentationForClass: each ].
	^ builder contents
]

{ #category : 'generating' }
Documentor >> exportPackageNamed: aPackageName toFile: aFileReference [
	| markdown |
	markdown := self documentPackageNamed: aPackageName.
	aFileReference writeStreamDo: [ :stream | stream nextPutAll: markdown ].
	^ aFileReference
]

{ #category : 'initialization' }
Documentor >> initialize [
	super initialize.
	builder := MicMicrodownTextualBuilder new
]

{ #category : 'initialization' }
Documentor >> resetBuilder [
	builder := MicMicrodownTextualBuilder new
]
