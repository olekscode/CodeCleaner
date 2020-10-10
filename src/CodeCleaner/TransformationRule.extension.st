Extension { #name : #TransformationRule }

{ #category : #'*CodeCleaner' }
TransformationRule >> allApplicableMethods [
	| selectors visitor methods |
	
	visitor := SelectorCollector new.
	antecedentTree acceptVisitor: visitor.
	selectors := visitor selectors.
	
	methods := selectors
		ifEmpty: [ Smalltalk image allClasses flatCollect: [ :eachClass | eachClass methods ] ]
		ifNotEmpty: [ (selectors inject: Set new into: [ :allSenders :selector | allSenders union: selector senders ]) ].
		
	methods := methods asOrderedCollection.
	^ methods select: [ :method | self canBeAppliedTo: method ].
]
