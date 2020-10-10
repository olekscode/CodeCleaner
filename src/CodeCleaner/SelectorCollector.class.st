Class {
	#name : #SelectorCollector,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'selectors'
	],
	#category : #CodeCleaner
}

{ #category : #initialization }
SelectorCollector >> initialize [ 
	super initialize.
	selectors := OrderedCollection new.
]

{ #category : #initialization }
SelectorCollector >> selectors [
	^ selectors
]

{ #category : #visiting }
SelectorCollector >> visitMessageNode: aNode [
	selectors add: aNode selector.
	super visitMessageNode: aNode.
]
