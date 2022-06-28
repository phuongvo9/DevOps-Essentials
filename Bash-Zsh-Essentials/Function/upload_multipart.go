package user_service

/*
1. Receive the image file from UploadAvatarHandler
2. Validate the image is correct or not (size, file extention,...)
3. Create a HTTP POST request to UPLOADCARE server with full properties (header, content-type, body, body_length,..)
*/

import (
	"bytes"
	"fmt"
	"io"
	"mime/multipart"
	"net/http"
	"path/filepath"
	"strings"
)

const (
	UPLOADCARE_PUB_KEY        = "abcxtz"
	UPLOADCARE_STORE          = "1" // mark the uploaded file  to UPLOADCARE CDN as stored - no delete
	UPLOADCARE_STORE_PROD_URL = "https://upload.uploadcare.com/"
)

type UploadCareRequest struct {
	Uploadcare_publickey string
	UPLOADCARE_STORE     string
	avatarfile           *multipart.FileHeader
	userid               string
}

// UploadImageToUploadCare Create POST HTTP request to UploadCare to upload avatar
func UploadImageToUploadCare(imageFileHeader *multipart.FileHeader) error {
	// validate and get the extension of the image {png,jpg,jpeg}
	_, err := GetImageContentType(imageFileHeader.Filename)
	if err != nil {
		return err
	}
	// validate file size - to refactor later
	if imageFileHeader.Size == 0 {
		return fmt.Errorf("File size is zero")
	}
	// New Multipart writer
	body := &bytes.Buffer{}
	writer := multipart.NewWriter(body)
	// 1st field - Public Key
	formWriter, err := writer.CreateFormField("UPLOADCARE_PUB_KEY")
	if err != nil {
		return err
	}
	_, err = io.Copy(formWriter, strings.NewReader(UPLOADCARE_PUB_KEY))
	if err != nil {
		return err
	}
	// 2nd field - STORE Option
	formWriter, err = writer.CreateFormField("UPLOADCARE_STORE")
	if err != nil {
		return err
	}
	_, err = io.Copy(formWriter, strings.NewReader(UPLOADCARE_STORE))
	if err != nil {
		return err
	}
	// 3rd file - avatar file
	formWriter, err = writer.CreateFormFile(imageFileHeader.Filename, imageFileHeader.Filename)
	if err != nil {
		return err
	}
	// convert byte slice to io.Reader
	imageioReader := bytes.NewReader(imageFileHeader.content)
	_, err = io.Copy(formWriter, imageioReader)
	if err != nil {
		return err
	}
	// close multipart writer
	err = writer.Close()
	if err != nil {
		return err
	}

	request, err := http.NewRequest("POST", UPLOADCARE_STORE_PROD_URL, body)
	if err != nil {
		return err
	}

	request.Header.Add("Content-Type", writer.FormDataContentType())
	client := &http.Client{}
	response, err := client.Do(request)
	if err != nil {
		return err
	}
	// Check the response
	if response.StatusCode != http.StatusOK {
		return fmt.Errorf("Reponse error - status: %s", response.Status)
	}
	return nil
}

type Form struct {
	body        *bytes.Buffer
	contentType string
	contentLen  int
}

func CreateHTTPRequestBody(imageFileHeader *multipart.FileHeader) (Form, error) {
	// validate and get the extension of the image {png,jpg,jpeg}
	_, err := GetImageContentType(imageFileHeader.Filename)
	if err != nil {
		return Form{}, err
	}
	// validate file size - to refactor later
	if imageFileHeader.Size == 0 {
		return Form{}, fmt.Errorf("File size is zero")
	}
	// create Header
	//theHeader := make(textproto.MIMEHeader)
	//theContentDisposition := mime.FormatMediaType("form-data", map[string]string{
	//	"name":     "images",
	//	"filename": imageFileHeader.Filename,
	//})
	//theHeader.Set("Content-Disposition", theContentDisposition)
	//theHeader.Set("Content-Type", imageContentType)
	//theHeader.Set("Content-Length", string(imageFileHeader.Size))

	return Form{}, nil
}

var imageContentType = map[string]string{
	"png":  "image/png",
	"jpg":  "image/jpg",
	"jpeg": "image/jpeg",
}

func GetImageContentType(imageName string) (string, error) {
	extension := filepath.Ext(imageName)
	if extension == "" {
		return "", fmt.Errorf("The file has no extention type: %s", imageName)
	}
	_, found := imageContentType[imageName]
	// map[ext] returns {no correct item and false} => no correct image type
	if !found {
		return extension, fmt.Errorf("The image extention is invalid")
	}
	return extension, nil
}
