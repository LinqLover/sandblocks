Class {
	#name : #SBCursorInsert,
	#superclass : #SBCursorPosition,
	#instVars : [
		'command',
		'before',
		'adjacent',
		'container',
		'bounds'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBCursorInsert >> = aPosition [

	^ aPosition class = self class and: [aPosition adjacent = self adjacent and: [aPosition before = self before and: [aPosition container = self container and: [self command hasSamePositionAs: aPosition command]]]]
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> adjacent [

	^ adjacent
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> adjacent: aBlock [

	adjacent := aBlock
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> before [

	^ before
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> before: aBoolean [

	before := aBoolean
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> block [

	^ (self adjacent ifNil: [self container]) containingSandblock
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> bounds [

	^ self boundsWithWidth: self lineWidth near: 0 @ 0
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> bounds: aRectangle [

	bounds := aRectangle
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> boundsWithWidth: aNumber near: aPoint [

	^ command insertBoundsWithSize: aNumber near: aPoint
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> color [

	^ self container colorPolicy selectionColorForBlock: (self container parentSandblock ifNil: [self container])
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> command [

	^ command
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> command: aBlock [

	command := aBlock
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> container [

	^ container
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> container: aBlock [

	container := aBlock
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> drawOn: aCanvas in: aRectangle color: aColor [

	SBToggledCode comment: '' active: 1 do: {
		[ | r |
			r := aRectangle expandBy: -1.
			aCanvas
				line: r topLeft
				to: (aRectangle height > 4 ifTrue: [r bottomLeft] ifFalse: [r topRight])
				width: (aRectangle height > 4 ifTrue: [aRectangle width] ifFalse: [aRectangle height])
				color: aColor
				dashLength: 1
				secondColor: Color transparent
				secondDashLength: 5
				startingOffset: 0].
		[aCanvas fillRectangle: aRectangle color: self color]}
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> enterWith: aCursor [

	super enterWith: aCursor.
	command title ifNotNil: [:title | aCursor showLabel: title].
	command suggestions ifNotEmpty: [:s |
		aCursor editor suggestionMenu
			suggestions: s;
			focusOnOpen: false;
			openNear: aCursor requestor: command]
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> hasHorizontalLayout [

	^ (command ifNil: [container]) hasHorizontalLayout
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> hash [

	^ self adjacent hash bitXor: (self before hash bitXor: self container hash)
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> horizontalOffsetInFloat [

	^ self block containingFloat
		ifNotNil: [:float | | reference |
			reference := self bounds center x.
			reference - float left]
		ifNil: [self bounds center x]
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> isDistinctFrom: aPosition [

	^ self class = aPosition class
		ifTrue: [(self command hasSamePositionAs: aPosition command) not]
		ifFalse: [self ~= aPosition]
]

{ #category : #testing }
SBCursorInsert >> isInsert [

	^ true
]

{ #category : #testing }
SBCursorInsert >> isJumpPoint [

	^ self secondaryInsertPosition not and: [self command isJumpPoint]
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> leaveIn: anEditor with: aCursor for: aNewPosition [

	aCursor showLabel: nil.
	aCursor editor suggestionMenu delete
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> lineWidth [

	^ 3
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> minimalBounds [

	^ self boundsWithWidth: 0 near: 0 @ 0
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> minimalBoundsNear: aPoint [

	^ self boundsWithWidth: 0 near: aPoint
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> mode [

	^ #insert
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> morph [

	^ self block
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> moveHorizontal: aNumber wordWise: aBoolean [

	| next |
	next := self adjacentPosition: aNumber in: self container sandblockEditor.
	^ (next class = self class and: [next command hasSamePositionAs: self command])
		ifTrue: [next adjacentPosition: aNumber in: self container sandblockEditor]
		ifFalse: [next]
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> objectInterface [

	^ self container
		objectInterfaceNear: self adjacent
		at: (self before ifTrue: [#before] ifFalse: [#after])
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> printOn: aStream [

	aStream nextPutAll: self className.
	aStream nextPut: $(.
	aStream print: self container.
	aStream nextPut: $)
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> secondaryInsertPosition [

	^ self command secondaryInsertPosition
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> selectLarger [

	^ SBCursorSelect new block: self container containingSandblock
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> selectSmaller [

	
]

{ #category : #'as yet unclassified' }
SBCursorInsert >> unhandledEvent: anEvent in: anEditor didHandle: aBlock [

	| ret |
	(anEvent keyCharacter isPrintable not or: [anEvent keyCharacter = Character tab and: [anEvent shiftPressed]]) ifTrue: [^ self].
	
	ret := command tryExpandWithInput: anEvent keyCharacter asString.
	ret == false ifTrue: [^ self].
	
	(ret isKindOf: SBCommand) ifTrue: [
		aBlock value.
		^ self].
	
	anEditor do: command.
	"anEditor selection inputContainedUnknown."
	(command continueAfterInsert: anEvent keyCharacter) ifTrue: [anEditor handle: anEvent].
	aBlock value
]
