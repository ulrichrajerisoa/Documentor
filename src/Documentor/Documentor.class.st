Class {
	#name : 'Documentor',
	#superclass : 'Object',
	#instVars : [
		'builder',
		'targetClass',
		'linter'
	],
	#category : 'Documentor',
	#package : 'Documentor'
}

{ #category : 'instance creation' }
Documentor class >> on: aClass [
	^ self new
		targetClass: aClass;
		yourself
]

{ #category : 'private' }
Documentor >> appendDocumentationForClass: aClass [
	| firstCommentParagraph superclassName |
	firstCommentParagraph := (aClass comment ifEmpty: [ 'No class comment.' ]) lines
		ifEmpty: [ 'No class comment.' ]
		ifNotEmpty: [ :lines | lines first ].
	superclassName := aClass superclass
		ifNil: [ 'nil' ]
		ifNotNil: [ :sup | sup name ].

	builder
		header: [ builder text: aClass name ] withLevel: 1;
		paragraph: [
			builder
				text: 'A subclass of ';
				monospace: superclassName;
				text: ', defined in package ';
				monospace: aClass package name ];
		paragraph: [ builder text: firstCommentParagraph ].

	self
		documentHierarchyOf: aClass;
		documentInstanceVariablesOf: aClass;
		documentMethodsWithCommentsOf: aClass;
		documentMetricsOf: aClass;
		documentLintOf: aClass
]

{ #category : 'generating' }
Documentor >> documentClass: aClass [
	self resetBuilder.
	self appendDocumentationForClass: aClass.
	^ builder contents
]

{ #category : 'private' }
Documentor >> documentHierarchyOf: aClass [
	| chain |
	chain := aClass allSuperclasses reversed copyWith: aClass.
	builder header: [ builder text: 'Hierarchy' ] withLevel: 2.
	builder unorderedListDuring: [
		chain do: [ :each | builder item: [ builder monospace: each name ] ] ]
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

{ #category : 'private' }
Documentor >> documentLintOf: aClass [
	| noInstVarMethods noSelfOrInstVarMethods totalComplexity |
	noInstVarMethods := (linter methodsWithoutDirectInstVarAccess: aClass)
		collect: [ :m | m selector ]
		as: SortedCollection.
	noSelfOrInstVarMethods := (linter methodsWithoutSelfOrInstVarAccess: aClass)
		collect: [ :m | m selector ]
		as: SortedCollection.
	totalComplexity := linter totalCyclomaticComplexityOf: aClass.

	builder header: [ builder text: 'Mini Linter' ] withLevel: 2.
	builder unorderedListDuring: [
		builder item: [
			builder
				text: 'Total cyclomatic complexity: ';
				text: totalComplexity asString ] ].

	builder header: [ builder text: 'Methods without direct instance variable access' ] withLevel: 3.
	noInstVarMethods
		ifEmpty: [ builder paragraph: [ builder text: 'None.' ] ]
		ifNotEmpty: [ :list |
			builder unorderedListDuring: [
				list do: [ :sel | builder item: [ builder monospace: sel ] ] ] ].

	builder header: [ builder text: 'Methods without self or instance variable access' ] withLevel: 3.
	noSelfOrInstVarMethods
		ifEmpty: [ builder paragraph: [ builder text: 'None.' ] ]
		ifNotEmpty: [ :list |
			builder unorderedListDuring: [
				list do: [ :sel | builder item: [ builder monospace: sel ] ] ] ]
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

{ #category : 'private' }
Documentor >> documentMethodsWithCommentsOf: aClass [
	builder header: [ builder text: 'Methods' ] withLevel: 2.
	aClass methods
		ifEmpty: [ builder paragraph: [ builder text: 'None.' ] ]
		ifNotEmpty: [ :methods |
			builder unorderedListDuring: [
				(methods sorted: [ :a :b | a selector < b selector ]) do: [ :method |
					| commentText |
					commentText := method comment ifNil: [ 'No comment.' ].
					builder item: [
						builder
							monospace: method selector;
							text: ' - ';
							text: commentText ] ] ] ]
]

{ #category : 'private' }
Documentor >> documentMetricsOf: aClass [
	| longMethods |
	builder header: [ builder text: 'Metrics' ] withLevel: 2.
	builder unorderedListDuring: [
		builder
			item: [
				builder
					text: 'Depth of inheritance: ';
					text: aClass allSuperclasses size asString ];
			item: [
				builder
					text: 'It inherits ';
					text: (aClass allInstVarNames size - aClass instVarNames size) asString;
					text: ' fields' ];
			item: [
				builder
					text: 'It defines ';
					text: aClass instVarNames size asString;
					text: ' fields' ];
			item: [
				builder
					text: 'It defines ';
					text: aClass methods size asString;
					text: ' methods' ];
			item: [
				builder
					text: 'It inherits ';
					text: (aClass allSelectors size - aClass selectors size) asString;
					text: ' methods' ];
			item: [
				builder
					text: 'Methods invoking super: ';
					text: (aClass methods count: [ :m | m sendsToSuper ]) asString ] ].
	longMethods := aClass selectors select: [ :each | each size > 25 ].
	builder header: [ builder text: 'Overly long method names' ] withLevel: 3.
	longMethods
		ifEmpty: [ builder paragraph: [ builder text: 'None.' ] ]
		ifNotEmpty: [ :list |
			builder unorderedListDuring: [
				list sorted do: [ :each | builder item: [ builder monospace: each ] ] ] ]
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
	linter := DocumentorLinter new.
	self resetBuilder
]

{ #category : 'generating' }
Documentor >> report [
	^ self documentClass: targetClass
]

{ #category : 'initialization' }
Documentor >> resetBuilder [
	builder := MicMicrodownTextualBuilder new
]

{ #category : 'accessing' }
Documentor >> targetClass: aClass [
	targetClass := aClass
]
