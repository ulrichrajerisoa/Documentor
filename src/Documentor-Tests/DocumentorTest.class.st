Class {
	#name : 'DocumentorTest',
	#superclass : 'TestCase',
	#category : 'Documentor-Tests',
	#package : 'Documentor-Tests'
}

{ #category : 'tests' }
DocumentorTest >> testDocumentClassHeaderAndComment [
	| doc result |
	doc := Documentor new.
	result := doc documentClass: Point.
	self assert: (result includesSubstring: '# Point').
	self assert: (result includesSubstring: Point comment)
]

{ #category : 'tests' }
DocumentorTest >> testDocumentClassVariablesAndMethods [
	| doc result |
	doc := Documentor new.
	result := doc documentClass: Point.
	self assert: (result includesSubstring: '## Instance Variables').
	self assert: (result includesSubstring: '`x`').
	self assert: (result includesSubstring: '`y`').
	self assert: (result includesSubstring: '## Methods').
	self assert: (result includesSubstring: '`distanceTo:`')
]
