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

{ #category : 'tests' }
DocumentorTest >> testDocumentPackage [
	| doc result |
	doc := Documentor new.
	result := doc documentPackageNamed: 'Documentor'.
	self assert: (result includesSubstring: '# Documentor').
	self assert: (result includesSubstring: '`builder`').
	self assert: (result includesSubstring: '`documentClass:`').
	self assert: (result includesSubstring: '`documentPackageNamed:`')
]

{ #category : 'tests' }
DocumentorTest >> testExportPackageToFile [
	| doc file result |
	doc := Documentor new.
	file := FileSystem memory workingDirectory / 'Documentor.md'.
	doc exportPackageNamed: 'Documentor' toFile: file.
	self assert: file exists.
	result := file contents.
	self assert: (result includesSubstring: '# Documentor')
]
