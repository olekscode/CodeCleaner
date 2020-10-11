Extension { #name : #TransformationRule }

{ #category : #'*CodeCleaner' }
TransformationRule >> allApplicableMethods [
	| selectors visitor methods |
	
	visitor := SelectorCollector new.
	antecedentTree acceptVisitor: visitor.
	selectors := visitor selectors.
	
	methods := selectors
		ifEmpty: [ Smalltalk image allClasses flatCollect: [ :eachClass | eachClass methods ] ]
		ifNotEmpty: [ (selectors inject: selectors first senders into: [ :allSenders :selector | allSenders intersection: selector senders ]) ].
		
	methods := methods asOrderedCollection.
	^ methods select: [ :method | self canBeAppliedTo: method ].
]
