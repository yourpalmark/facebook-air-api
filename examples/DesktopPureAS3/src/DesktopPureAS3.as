package {
	
	import com.adobe.serialization.json.JSON;
	import com.facebook.graph.FacebookDesktop;
	
	import flash.desktop.NativeApplication;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	[SWF(width="650", height="700", backgroundColor="0xffffff", frameRate="15")]
	public class DesktopPureAS3 extends Sprite {
		
		// Static/Constant Properties:
		
		protected static const APP_ID:String = "YOUR_APP_ID_GOES_HERE"; // Your App ID.
		protected static const APP_ORIGIN:String = "YOUR_APP_URL"; // The site URL of your application (specified in your app settings); needed for clearing cookie when logging out.
		
		// Public Properties:
		
		public var loginBtn:Sprite;
		public var loginBtnLabel:TextField;
		public var methodText:TextField;
		public var methodInputText:TextField;
		public var postBtn:Sprite;
		public var postBtnLabel:TextField;
		public var getBtn:Sprite;
		public var getBtnLabel:TextField;
		public var postNoteText:TextField;
		public var postInputText:TextField;
		public var outputNoteText:TextField;
		public var clearBtn:Sprite;
		public var clearBtnLabel:TextField;
		public var outputText:TextField;
		
		// Protected Properties:
		
		protected var isLoggedIn:Boolean = false;
		protected var permissions:Array = ["read_stream"];
		
		// Getter/Setter Properties:
		
		// Initialization:
		public function DesktopPureAS3() {
			configUI();
			FacebookDesktop.init(APP_ID, handleInit);
			addEventListener(Event.DEACTIVATE, handleDeactivate, false, 0, true);
		}
		
		// Protected Methods:
		
		protected function configUI():void {
			loginBtn = new Sprite();
			setBtnState(loginBtn, "up");
			loginBtnLabel = new TextField();
			setupTextField(loginBtnLabel);
			setBtnLabelText(loginBtn, loginBtnLabel, "Login");
			loginBtn.addChild(loginBtnLabel);
			loginBtn.x = 10;
			loginBtn.y = 10;
			loginBtn.addEventListener(MouseEvent.MOUSE_DOWN, handleLoginBtnMouseDown, false, 0, true);
			loginBtn.addEventListener(MouseEvent.CLICK, handleLoginBtnClick, false, 0, true);
			addChild(loginBtn);
			
			methodText = new TextField();
			setupTextField(methodText);
			methodText.text = "method:";
			methodText.x = 10;
			methodText.y = loginBtn.y + loginBtn.height + 20;
			addChild(methodText);
			
			methodInputText = new TextField();
			methodInputText.type = TextFieldType.INPUT;
			methodInputText.defaultTextFormat = new TextFormat("_sans", 14);
			methodInputText.border = true;
			methodInputText.text = "/me";
			methodInputText.width = 260;
			methodInputText.height = methodInputText.textHeight + 5;
			methodInputText.x = methodText.x + methodText.width + 10;
			methodInputText.y = methodText.y;
			addChild(methodInputText);
			
			postBtn = new Sprite();
			setBtnState(postBtn, "up");
			postBtnLabel = new TextField();
			setupTextField(postBtnLabel);
			setBtnLabelText(postBtn, postBtnLabel, "Post");
			postBtn.addChild(postBtnLabel);
			postBtn.x = methodInputText.x + methodInputText.width + 10;
			postBtn.y = methodInputText.y;
			postBtn.addEventListener(MouseEvent.MOUSE_DOWN, handlePostBtnMouseDown, false, 0, true);
			postBtn.addEventListener(MouseEvent.CLICK, handlePostBtnClick, false, 0, true);
			addChild(postBtn);
			
			getBtn = new Sprite();
			setBtnState(getBtn, "up");
			getBtnLabel = new TextField();
			setupTextField(getBtnLabel);
			setBtnLabelText(getBtn, getBtnLabel, "Get");
			getBtn.addChild(getBtnLabel);
			getBtn.x = postBtn.x + postBtn.width + 10;
			getBtn.y = methodInputText.y;
			getBtn.addEventListener(MouseEvent.MOUSE_DOWN, handleGetBtnMouseDown, false, 0, true);
			getBtn.addEventListener(MouseEvent.CLICK, handleGetBtnClick, false, 0, true);
			addChild(getBtn);
			
			postNoteText = new TextField();
			setupTextField(postNoteText);
			postNoteText.wordWrap = true;
			postNoteText.multiline = true;
			postNoteText.text = "Place JSON encoded string here to pass in POST request arguments.\nFor example, for Graph API call: /me/feed\n{ \"message\" : \"I am a message!\" }";
			postNoteText.width = 500;
			postNoteText.x = 10;
			postNoteText.y = methodText.y + methodText.height + 10;
			addChild(postNoteText);
			
			postInputText = new TextField();
			postInputText.type = TextFieldType.INPUT;
			postInputText.defaultTextFormat = new TextFormat("_sans", 14);
			postInputText.border = true;
			postInputText.wordWrap = true;
			postInputText.multiline = true;
			postInputText.width = 630;
			postInputText.height = 90;
			postInputText.x = 10;
			postInputText.y = postNoteText.y + postNoteText.height + 10;
			addChild(postInputText);
			
			outputNoteText = new TextField();
			setupTextField(outputNoteText);
			outputNoteText.text = "output: The API result appears below in a JSON encoded string";
			outputNoteText.x = 10;
			outputNoteText.y = postInputText.y + postInputText.height + 20;
			addChild(outputNoteText);
			
			clearBtn = new Sprite();
			setBtnState(clearBtn, "up");
			clearBtnLabel = new TextField();
			setupTextField(clearBtnLabel);
			setBtnLabelText(clearBtn, clearBtnLabel, "Clear");
			clearBtn.addChild(clearBtnLabel);
			clearBtn.x = stage.stageWidth - clearBtn.width - 10;
			clearBtn.y = outputNoteText.y;
			clearBtn.addEventListener(MouseEvent.MOUSE_DOWN, handleClearBtnMouseDown, false, 0, true);
			clearBtn.addEventListener(MouseEvent.CLICK, handleClearBtnClick, false, 0, true);
			addChild(clearBtn);
			
			outputText = new TextField();
			outputText.defaultTextFormat = new TextFormat("_sans", 14);
			outputText.x = 10;
			outputText.y = outputNoteText.y + outputNoteText.height + 10;
			outputText.border = true;
			outputText.wordWrap = true;
			outputText.multiline = true;
			outputText.width = 630;
			outputText.height = stage.stageHeight - outputText.y - 10;
			addChild(outputText);
		}
		
		protected function setupTextField(textField:TextField):void {
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.selectable = false;
			textField.defaultTextFormat = new TextFormat("_sans", 14);
		}
		
		protected function setBtnLabelText(button:Sprite, label:TextField, text:String):void {
			label.text = text;
			label.x = (button.width >> 1) - (label.width >> 1);
			label.y = (button.height >> 1) - (label.height >> 1);
		}
		
		protected function setBtnState(button:Sprite, state:String):void {
			var g:Graphics = button.graphics;
			g.clear();
			var matr:Matrix = new Matrix();
			matr.createGradientBox(30, 21, Math.PI * 0.5, 0, 0);
			switch (state) {
				case "up":
					button.x -= 1;
					button.y -= 1;
					g.lineStyle(1, 0x333333, 1, true);
					g.beginGradientFill(GradientType.LINEAR, [0xffffff, 0xcccccc], [1, 1], [0, 255], matr);
					break;
				case "down":
					button.x += 1;
					button.y += 1;
					g.lineStyle(1, 0x000000, 1, true);
					g.beginGradientFill(GradientType.LINEAR, [0xffffff, 0xaaaaaa], [1, 1], [0, 255], matr);
					break;
			}
			g.drawRoundRect(0, 0, 100, 21, 10, 10);
			g.endFill();
		}
		
		// Event Handlers:
		
		protected function handleInit(result:Object, fail:Object):void {
			if (result) { // User is already logged in.
				setBtnLabelText(loginBtn, loginBtnLabel, "Logout");
				isLoggedIn = true;
			} else { // User hasn't logged in.
				
			}
		}
		
		protected function handleLogin(result:Object, fail:Object):void {
			if (result) { // User successfully logged in.
				setBtnLabelText(loginBtn, loginBtnLabel, "Logout");
				isLoggedIn = true;
			} else { // User unsuccessfully logged in.
				
			}
		}
		
		protected function handleLogout(success:Boolean):void {
			setBtnLabelText(loginBtn, loginBtnLabel, "Login");
			isLoggedIn = false;
		}
		
		protected function handleLoginBtnClick(event:MouseEvent):void {
			if (isLoggedIn) {
				FacebookDesktop.logout(handleLogout, APP_ORIGIN);
			} else {
				FacebookDesktop.login(handleLogin, permissions);
			}
		}
		
		protected function handlePostBtnClick(event:MouseEvent):void {
			if (isLoggedIn) {
				var params:Object = null;
				try {
					params = JSON.decode(postInputText.text);
				} catch (e:Error) {
					outputText.appendText("\n\nERROR DECODING JSON: " + e.message);
				}
				FacebookDesktop.api(methodInputText.text, handleAPICall, params, "POST");
			}
		}
		
		protected function handleGetBtnClick(event:MouseEvent):void {
			if (isLoggedIn) {
				FacebookDesktop.api(methodInputText.text, handleAPICall, null, "GET");
			}
		}
		
		protected function handleClearBtnClick(event:MouseEvent):void {
			outputText.text = "";
		}
		
		protected function handleAPICall(result:Object, fail:Object):void {
			if (result) {
				outputText.appendText("\n\nRESULT:\n" + JSON.encode(result)); 
			} else {
				outputText.appendText("\n\nFAIL:\n" + JSON.encode(fail)); 
			}
		}
		
		protected function handleLoginBtnMouseDown(event:MouseEvent):void {
			setBtnState(loginBtn, "down");
			stage.addEventListener(MouseEvent.MOUSE_UP, handleLoginBtnStageMouseUp, false, 0, true);
		}
		
		protected function handleLoginBtnStageMouseUp(event:MouseEvent):void {
			setBtnState(loginBtn, "up");
			stage.removeEventListener(MouseEvent.MOUSE_UP, handleLoginBtnStageMouseUp);
		}
		
		protected function handlePostBtnMouseDown(event:MouseEvent):void {
			if (isLoggedIn) {
				setBtnState(postBtn, "down");
				stage.addEventListener(MouseEvent.MOUSE_UP, handlePostBtnStageMouseUp, false, 0, true);
			}
		}
		
		protected function handlePostBtnStageMouseUp(event:MouseEvent):void {
			setBtnState(postBtn, "up");
			stage.removeEventListener(MouseEvent.MOUSE_UP, handlePostBtnStageMouseUp);
		}
		
		protected function handleGetBtnMouseDown(event:MouseEvent):void {
			if (isLoggedIn) {
				setBtnState(getBtn, "down");
				stage.addEventListener(MouseEvent.MOUSE_UP, handleGetBtnStageMouseUp, false, 0, true);
			}
		}
		
		protected function handleGetBtnStageMouseUp(event:MouseEvent):void {
			setBtnState(getBtn, "up");
			stage.removeEventListener(MouseEvent.MOUSE_UP, handleGetBtnStageMouseUp);
		}
		
		protected function handleClearBtnMouseDown(event:MouseEvent):void {
			setBtnState(clearBtn, "down");
			stage.addEventListener(MouseEvent.MOUSE_UP, handleClearBtnStageMouseUp, false, 0, true);
		}
		
		protected function handleClearBtnStageMouseUp(event:MouseEvent):void {
			setBtnState(clearBtn, "up");
			stage.removeEventListener(MouseEvent.MOUSE_UP, handleClearBtnStageMouseUp);
		}
		
		protected function handleDeactivate(event:Event):void {
			FacebookDesktop.logout(handleLogout, APP_ORIGIN);
			NativeApplication.nativeApplication.exit();
		}
		
	}
	
}