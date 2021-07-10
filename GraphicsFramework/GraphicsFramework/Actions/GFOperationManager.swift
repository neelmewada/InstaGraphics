//
//  GFAction.swift
//  GraphicsFramework
//
//  Created by Neel Mewada on 29/05/21.
//

import UIKit

/// A class that records and manages all operations.
public class GFOperationManager {
    // MARK: - Init
    
    public init(_ editor: GFEditorView) {
        self.editor = editor
    }
    
    // MARK: - Private Properties
    
    private weak var editor: GFEditorView!
    
    private weak var canvas: GFCanvas! {
        return editor.canvas
    }
    
    private var operationStack: [GFOperation] = []
    
    private var currentOperation: Int = -1
        
    // MARK: - Public Properties
    
    public var numberOfOperations: Int {
        return operationStack.count
    }
    
    public var undosRemaining: Int {
        return currentOperation + 1
    }
    
    public var redosRemaining: Int {
        return operationStack.count - currentOperation - 1
    }
    
    // MARK: - Private Methods
    
    private func pushOperation(_ operation: GFOperation) {
        operationStack.append(operation)
        currentOperation = operationStack.count - 1
    }
    
    private func popOperation() -> GFOperation {
        let operation = operationStack.removeLast()
        currentOperation = operationStack.count - 1
        return operation
    }
    
    // MARK: - Public Methods
    
    public func recordOperation(_ initialState: [GFCodableElement], _ finalState: [GFCodableElement]) {
        if currentOperation < operationStack.count - 1 {
            operationStack.removeSubrange((currentOperation + 1)..<operationStack.count)
        }
        
        let operation = GFOperation(initialState, finalState)
        pushOperation(operation)
    }
    
    public func undoOperation() {
        if undosRemaining <= 0 || currentOperation < 0 {
            return
        }
        
        //let operation = popOperation()
        let operation = operationStack[currentOperation]
        currentOperation -= 1
        
        for serializedElement in operation.initialState {
            // if element exists both in initial & final state
            if operation.finalState.contains(where: { $0.id == serializedElement.id }) { // then configure it to initial serialized state
                let element = editor.findElement(withId: serializedElement.id)
                element!.configure(from: serializedElement)
            } else { // if element exists in initial state, but doesn't exist in final state, i.e. it was deleted
                canvas.addElement(from: serializedElement, autoSelect: false) // re-add it
            }
        }
        
        for serializedElement in operation.finalState {
            // if element exists in final state but NOT in initial state
            if operation.initialState.allSatisfy({ $0.id != serializedElement.id }) { // then delete it
                canvas.removeElement(withId: serializedElement.id)
            }
        }
        
        editor.layoutUpdate()
    }
    
    public func redoOperation() {
        if redosRemaining <= 0 {
            return
        }
        
        let operation = operationStack[currentOperation + 1]
        currentOperation += 1
        
        for serializedElement in operation.initialState {
            // if element exists both in initial & final state
            if let index = operation.finalState.firstIndex(where: { $0.id == serializedElement.id }) { // then configure it to final state
                let element = editor.findElement(withId: serializedElement.id)
                element!.configure(from: operation.finalState[index])
            } else { // element exists in initial state but NOT in final
                canvas.removeElement(withId: serializedElement.id) // delete it
            }
        }
        
        for serializedElement in operation.finalState {
            // if element exists in final state but NOT in initial state
            if operation.initialState.allSatisfy({ $0.id != serializedElement.id }) { // then add it
                canvas.addElement(from: serializedElement, autoSelect: false)
            }
        }
        
        editor.layoutUpdate()
    }
}


