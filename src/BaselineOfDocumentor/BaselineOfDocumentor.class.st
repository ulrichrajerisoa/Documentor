Class {
	#name : 'BaselineOfDocumentor',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfDocumentor',
	#package : 'BaselineOfDocumentor'
}

{ #category : 'baselines' }
BaselineOfDocumentor >> baseline: spec [
	<baseline>
	spec for: #common do: [
		spec
			package: 'Documentor';
			package: 'Documentor-Tests' with: [ spec requires: #( 'Documentor' ) ] ]
]
