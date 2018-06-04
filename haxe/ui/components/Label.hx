package haxe.ui.components;

import haxe.ui.util.Variant;
import haxe.ui.core.Component;
import haxe.ui.core.DataBehaviour;
import haxe.ui.layouts.DefaultLayout;
import haxe.ui.styles.Style;
import haxe.ui.util.Size;

class Label extends Component {
    //***********************************************************************************************************
    // Styles
    //***********************************************************************************************************
    @:style(layout)           public var textAlign:Null<String>;
    
    //***********************************************************************************************************
    // Public API
    //***********************************************************************************************************
    @:behaviour(TextBehaviour)  public var text:String;
    
    //***********************************************************************************************************
    // Internals
    //***********************************************************************************************************
    private override function createDefaults() { // TODO: remove this eventually, @:layout(...) or something
        super.createDefaults();
        _defaultLayout = new LabelLayout();
    }
    
    //***********************************************************************************************************
    // Overrides
    //***********************************************************************************************************
    private override function get_value():Variant {
        return text;
    }
    private override function set_value(value:Variant):Variant {
        text = value;
        return value;
    }

    private override function applyStyle(style:Style) {  // TODO: remove this eventually, @:styleApplier(...) or something
        super.applyStyle(style);
        if (hasTextDisplay() == true) {
            getTextDisplay().textStyle = style;
        }
    }
}

//***********************************************************************************************************
// Composite Layout
//***********************************************************************************************************
@:dox(hide) @:noCompletion
private class LabelLayout extends DefaultLayout {
    private override function resizeChildren() {
        if (component.autoWidth == false) {
            component.getTextDisplay().width = component.componentWidth - paddingLeft - paddingRight;

             // TODO: make not specific - need to check all backends first
            #if (flixel)
            component.getTextDisplay().wordWrap = true;
            component.getTextDisplay().tf.autoSize = false;
            #elseif (openfl)
            component.getTextDisplay().textField.autoSize = openfl.text.TextFieldAutoSize.NONE;
            component.getTextDisplay().multiline = true;
            component.getTextDisplay().wordWrap = true;
            #elseif (pixijs)
            component.getTextDisplay().textField.style.wordWrapWidth = component.getTextDisplay().width;
            component.getTextDisplay().wordWrap = true;
            #else
            component.getTextDisplay().wordWrap = true;
            #end
        }
        
        if (component.autoHeight == true) {
            component.getTextDisplay().height = component.getTextDisplay().textHeight;
        } else {
            component.getTextDisplay().height = component.height;
        }
    }

    private override function repositionChildren() {
        if (component.hasTextDisplay() == true) {
            component.getTextDisplay().left = paddingLeft;
            component.getTextDisplay().top = paddingTop;
        }
    }

    public override function calcAutoSize(exclusions:Array<Component> = null):Size {
        var size:Size = super.calcAutoSize(exclusions);
        if (component.hasTextDisplay() == true) {
            size.width += component.getTextDisplay().textWidth;
            size.height += component.getTextDisplay().textHeight;
        }
        return size;
    }

    private function textAlign(child:Component):String {
        if (child == null || child.style == null || child.style.textAlign == null) {
            return "left";
        }
        return child.style.textAlign;
    }
}

//***********************************************************************************************************
// Behaviours
//***********************************************************************************************************
@:dox(hide) @:noCompletion
private class TextBehaviour extends DataBehaviour {
    public override function validateData() {
        _component.getTextDisplay().text = '${_value}';
    }
}