Class {
	#name : #CodeCleaner,
	#superclass : #SpPresenter,
	#instVars : [
		'rules',
		'ruleMethodMapping',
		'packageRuleMapping',
		'packageList',
		'ruleList',
		'methodList',
		'oldSourceCode',
		'newSourceCode',
		'applyButton'
	],
	#category : #'CodeCleaner-Spec'
}

{ #category : #specs }
CodeCleaner class >> defaultSpec [ 
	^ SpBoxLayout newVertical
		spacing: 4;
		add: (SpBoxLayout newHorizontal
			spacing: 4;
			add: (SpBoxLayout newVertical
				add: 'Packages' height: self labelHeight;
				add: #packageList;
				yourself);
			add: (SpBoxLayout newVertical
				add: 'Rules' height: self labelHeight;
				add: #ruleList;
				yourself);
			add: (SpBoxLayout newVertical
				add: 'Applicable methods' height: self labelHeight;
				add: #methodList;
				yourself);
			yourself);
		add: (SpBoxLayout newHorizontal
			spacing: 4;
			add: (SpBoxLayout newVertical
				add: 'Old source code' height: self labelHeight;
				add: #oldSourceCode;
				yourself);
			add: (SpBoxLayout newVertical
				add: 'New source code' height: self labelHeight;
				add: #newSourceCode;
				yourself);
			yourself);
		add: (SpBoxLayout newHorizontal
			add: '';
			add: #applyButton width: self buttonWidth;
			yourself) height: self buttonHeight;
		yourself.
]

{ #category : #settings }
CodeCleaner class >> defaultTitle [
	^ 'Code Cleaner'
]

{ #category : #settings }
CodeCleaner class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #'Code Cleaner')
		parent: #Tools;
		action: [ self open ];
		order: 15;
		help: 'A tool for cleaning the source code using the predefined rules';
		icon: (self iconNamed: #repair).
]

{ #category : #examples }
CodeCleaner class >> open [
	<example>
	self new openWithSpec.
]

{ #category : #settings }
CodeCleaner class >> preferredExtent [
	^ 900@600
]

{ #category : #'as yet unclassified' }
CodeCleaner >> allApplicableMethodsForRule: aRule inPackages: aCollectionOfPackages [
	^ aCollectionOfPackages size > 20
		ifTrue: [
			aRule allApplicableMethods select: [ :method |
				aCollectionOfPackages includes: method origin package ] ]
		ifFalse: [ 
			(aCollectionOfPackages flatCollect: [ :package | package methods ]) select: [ :method |
				aRule canBeAppliedTo: method ] ]
]

{ #category : #'as yet unclassified' }
CodeCleaner >> applyRule [
	| method rule |
	method := methodList selectedItem.
	rule := ruleList selectedItem.
	
	rule applyTo: method.
	
	self showMethods.
]

{ #category : #'as yet unclassified' }
CodeCleaner >> calculateMappings [
	ruleMethodMapping := Dictionary new.

	rules
		do: [ :rule | ruleMethodMapping at: rule put: rule allApplicableMethods asSet ]
		displayingProgress: [ :rule | rule antecedent ].
	
	packageRuleMapping := Dictionary new.
	
	ruleMethodMapping keysAndValuesDo: [ :rule :methods |
		methods do: [ :method |
			(packageRuleMapping at: method package ifAbsentPut: [ Set new ]) add: rule ] ].
]

{ #category : #initialization }
CodeCleaner >> connectPresenters [ 
	super connectPresenters.
	
	ruleList whenSelectionChangedDo: [ :selection |
		self showMethods ]. 
	
	packageList whenSelectionChangedDo: [ :selection |
		self showRules ].
	
	methodList whenSelectionChangedDo: [ :selection |
		self showSourceCode ].
	
	applyButton action: [ 
		self applyRule ].
]

{ #category : #initialization }
CodeCleaner >> initializePresenters [
	super initializePresenters.
	
	packageList := self newList
		items: Smalltalk image packages;
		display: [ :package | package name ];
		beMultipleSelection;
		yourself.
		
	ruleList := self newList
		display: [ :rule | rule antecedent, ' -> ', rule consequent ];
		yourself.
		
	methodList := self newList
		display: [ :method | method name ];
		yourself.
	
	oldSourceCode := self newCode
		withoutLineNumbers;
		yourself.
		
	newSourceCode := self newCode
		withoutLineNumbers;
		yourself.
	
	applyButton := self newButton
		label: 'Apply';
		disable;
		yourself.
		
	self loadRules.
]

{ #category : #initialization }
CodeCleaner >> initializeWindow: aWindowPresenter [
	super initializeWindow: aWindowPresenter.
	
	aWindowPresenter
		title: self class defaultTitle;
		initialExtent: self class preferredExtent.
]

{ #category : #accessing }
CodeCleaner >> loadRules [
	| fileReference loadedRules |
	
	fileReference := Path workingDirectory asFileReference / 'pharo-local' / 'iceberg' / 'olekscode' / 'CodeCleaner' / 'data' / 'rules.ston'.
	
	loadedRules := fileReference readStreamDo: [ :stream | 
		STON fromStream: stream ].
	
	loadedRules := loadedRules collect: [ :rule | rule asTransformationRule ].
	self rules: loadedRules.
]

{ #category : #accessing }
CodeCleaner >> rules: aCollectionOfRules [
	rules := aCollectionOfRules.
	self showRules.
	self calculateMappings.
]

{ #category : #'as yet unclassified' }
CodeCleaner >> showMethods [
	(ruleList selectedItem isNil or: [ packageList selectedItems isEmpty ])
		ifTrue: [
			methodList items: {}.
			^ self ].
			
	methodList items: ((ruleMethodMapping at: ruleList selectedItem) select: [ :method |
		packageList selectedItems includes: method package ]) asOrderedCollection.
]

{ #category : #'as yet unclassified' }
CodeCleaner >> showRules [
	(rules isNil or: [ packageList selectedItems isEmpty ])
		ifTrue: [
			ruleList items: {  }.
			^ self ].
		
	ruleList items: (packageList selectedItems flatCollect: [ :package | 
		packageRuleMapping at: package ifAbsent: [ Set new ] ]) asSet asOrderedCollection.
]

{ #category : #'as yet unclassified' }
CodeCleaner >> showSourceCode [
	| method rule |
	
	method := methodList selectedItem.
	rule := ruleList selectedItem.
	
	(method isNil or: [ rule isNil ]) ifTrue: [
		oldSourceCode text: ''.
		newSourceCode text: ''.
		applyButton disable.
		^ self ].
	
	oldSourceCode beForMethod: method.
	oldSourceCode text: method sourceCode.
	
	newSourceCode beForMethod: method.
	newSourceCode text: (rule transformedSourceCodeOf: method).
	
	applyButton enable.
]
