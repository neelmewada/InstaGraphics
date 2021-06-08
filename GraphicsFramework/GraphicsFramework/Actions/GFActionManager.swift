//
//  GFActionManager.swift
//  GraphicsFramework
//
//  Created by Neel Mewada on 01/06/21.
//

import UIKit

public class GFActionManager {
    // MARK: - Init
    
    public init(_ editor: GFEditorView) {
        self.editor = editor
    }
    
    // MARK: - Private Properties
    
    private weak var editor: GFEditorView!
    
    private weak var canvas: GFCanvas! {
        return editor.canvas
    }
    
    private var initialState: [GFCodableElement] = []
    private var currentState: [GFCodableElement] = []
    
    // MARK: - Public Properties
    
    public private(set) var recordedElements: [GFElement] = []
    
    public var isRecording: Bool { recordedElements.count > 0 }
    
    // MARK: - Private Methods
    
    private func updateElements(_ input: [GFElement], _ output: [GFElement]) {
        for element in input {
            if !output.contains(where: { $0.id == element.id }) { // if the element was deleted
                canvas.removeElement(element) // then remove it
            }
        }
        
        for element in output {
            if !input.contains(where: { $0.id == element.id }) { // if a new element was created
                canvas.addElement(element) // then add it
            }
        }
    }
    
    // MARK: - Public Methods
    
    public func performAction(_ action: GFAction, on elements: [GFElement]) {
        if !action.isValid(on: elements) {
            return
        }
        
        // if we're recording, and an element in elements array isn't being recorded, then return
        if isRecording && elements.contains(where: { !recordedElements.contains($0) }) {
            return
        }
        
        if isRecording { // don't push the operation directly if we're recording
            let input = elements
            let output = action.perform(on: elements)
            for element in output {
                if let index = self.currentState.firstIndex(where: { $0.id == element.id }) { // if element exists in currentState, then update it
                    self.currentState[index] = element.serializedValue
                } else { // if this element doesn't exist in current state, then create & add it
                    self.currentState.append(element.serializedValue)
                }
            }
            updateElements(input, output)
            return // Don't record the states & operation if we're already in recording mode
        }
        
        let input = elements
        let output = action.perform(on: elements)
        
        let initialState = input.compactMap{ $0.serializedValue }
        let finalState = output.compactMap{ $0.serializedValue }
        
        // update to apply new or deleted elements
        updateElements(input, output)
        
        // Finally, record the operation to the stack
        editor.operationManager.recordOperation(initialState, finalState)
    }
    
    public func startRecording(elements: [GFElement]) {
        if isRecording {
            print("Recording FAILED to start.")
            return
        }
        
        self.initialState = elements.compactMap{ $0.serializedValue }
        
        print("Recording START. count: \(initialState.count)")
        print("\(initialState)")
        
        self.recordedElements = elements
    }
    
    public func stopRecording() {
        if !isRecording {
            return
        }
        
        var finalState = recordedElements.compactMap{ $0.serializedValue }
        
        for element in currentState {
            if !finalState.contains(where: { $0.id == element.id }) {
                finalState.append(element)
            }
        }
        
        print("Recording END. count: \(finalState.count)")
        print("\(finalState)")
        
        editor.operationManager.recordOperation(initialState, finalState)
        
        initialState.removeAll()
        currentState.removeAll()
        self.recordedElements.removeAll()
    }
}
