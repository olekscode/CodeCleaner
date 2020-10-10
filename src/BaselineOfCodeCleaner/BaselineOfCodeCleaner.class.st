Class {
	#name : #BaselineOfCodeCleaner,
	#superclass : #BaselineOf,
	#category : #BaselineOfCodeCleaner
}

{ #category : #baselines }
BaselineOfCodeCleaner >> baseline: spec [
	<baseline>
	spec for: #common do: [	
		"External dependencies"
		spec
			baseline: 'TransformationRule'
			with: [ spec repository: 'github://olekscode/TransformationRule/src' ].
			
		spec
			baseline: 'FileDialog'
			with: [ spec repository: 'github://Ducasse/file-dialog/repository' ].
				
		"Packages"
		spec 
			package: 'CodeCleaner' with: [ spec requires: #('TransformationRule') ];
			package: 'CodeCleaner-Tests' with: [ spec requires: #('CodeCleaner') ];
			package: 'CodeCleaner-Spec' with: [ spec requires: #('CodeCleaner' 'FileDialog') ] ]
]
