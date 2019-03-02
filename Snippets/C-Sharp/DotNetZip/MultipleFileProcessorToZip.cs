if (Request.HttpMethod == "POST")
    {
      HttpFileCollectionBase fff = Request.Files;
      uploadFileModel = BLL.FormProcessor.MultipleFileProcessor.Post(Request.Files);					
      Response.End();
    }



using Ionic.Zip;
public static UploadFileModel Post(HttpFileCollectionBase postedFiles, string jobName)
		{
			UploadFileModel result = new UploadFileModel();
			byte[] zipFileByes = new byte[] { };


			using (var zip = new ZipFile())
			{
				foreach (var objFile in postedFiles.AllKeys)
				{
					HttpPostedFileBase file = postedFiles[objFile];

					//// Get file info
					var fileName = Path.GetFileName(file.FileName).ToStringOrDefault();

					if (fileName.IsEmpty() || file.ContentLength == 0)
						continue;
					
					//// Get file data
					byte[] data = new byte[] { };
					using (var binaryReader = new BinaryReader(file.InputStream))
					{
						data = binaryReader.ReadBytes(file.ContentLength);
						zip.AddEntry(fileName, data);
					}
				}

				// zip.Count();
				// zip.Save("J:\\_temp/ZipFile.zip");

				MemoryStream memoryStream = new MemoryStream();
				zip.Save(memoryStream);
				
				result = new UploadFileModel
				{
					FileStore = memoryStream.ToArray(),
					FileName = jobName + ".zip",
					ContentType = "application/zip",
					ContentLength = memoryStream.Length.ToInt32OrDefault(),
					CreatedDate = DateTime.Now,

				};


			}
			
			return result;

		}
