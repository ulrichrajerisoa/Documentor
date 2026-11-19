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
	^ builder contents
]

{ #category : 'initialization' }
Documentor >> initialize [
	super initialize.
	builder := MicMicrodownTextualBuilder new
]
