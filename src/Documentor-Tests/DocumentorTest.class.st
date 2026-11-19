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
