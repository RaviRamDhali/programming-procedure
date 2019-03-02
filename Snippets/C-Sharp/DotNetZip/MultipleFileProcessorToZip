if (Request.HttpMethod == "POST")
    {
      HttpFileCollectionBase fff = Request.Files;
      uploadFileModel = BLL.FormProcessor.MultipleFileProcessor.Post(Request.Files);					
      Response.End();
    }



using Ionic.Zip;
public class MultipleFileProcessor
	{
		public static UploadFileModel Post(HttpFileCollectionBase postedFiles)
		{
			using (var zip = new ZipFile())
			{
				foreach (var objFile in postedFiles.AllKeys)
				{
					HttpPostedFileBase file = postedFiles[objFile];

					//// Get file info
					var fileName = Path.GetFileName(file.FileName);
					var contentLength = file.ContentLength;
					var contentType = file.ContentType;

					//// Get file data
					byte[] data = new byte[] { };
					using (var binaryReader = new BinaryReader(file.InputStream))
					{
						data = binaryReader.ReadBytes(file.ContentLength);
						zip.AddEntry(fileName, data);
					}
				}

				zip.Count();
				zip.Save("J:\\_temp/ZipFile.zip");
			}

			var uploadFileModel = new UploadFileModel();
			return uploadFileModel;

		}

	}
