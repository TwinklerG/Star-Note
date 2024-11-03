import http from '@ohos.net.http';
import { BusinessError } from '@kit.BasicServicesKit';
import { image } from '@kit.ImageKit';

@Component
export default struct RandomPicture {
  @Consume("WebPageStack") aboutPageStack: NavPathStack;
  @State image: PixelMap | undefined = undefined;
  aboutToAppear(): void {
    this.getPicture()
  }
  build() {
    NavDestination() {
      Text($r("app.string.2D_tip"))
        .width("90%")
        .fontWeight(FontWeight.Medium)
        .textAlign(TextAlign.Center)
      Image(this.image)
        .onClick(() => {
          this.getPicture()
          console.log("change picture")
        })
    }
    .hideTitleBar(true)
  }
  getPicture() {
    let OutData: http.HttpResponse
    http.createHttp().request("https://api.lypce.com/pe.php",
      (error: BusinessError, data: http.HttpResponse) => {
        if (error) {
          console.error(`http request failed with. Code: ${error.code}, message: ${error.message}`);
        } else {
          OutData = data
          let code: http.ResponseCode | number = OutData.responseCode
          if (http.ResponseCode.OK === code) {
            let imageData: ArrayBuffer = OutData.result as ArrayBuffer;
            let imageSource: image.ImageSource = image.createImageSource(imageData);
            imageSource.createPixelMap().then((pixelMap: PixelMap) => {
              this.image = pixelMap
            })
          }
        }
      }
    )
  }
}