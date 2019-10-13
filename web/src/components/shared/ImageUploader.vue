<template>
  <div class="row">
    <!-- Spinner that displays during image upload -->
    <div v-if="uploading && !uploadEnd" id="loader">
      <div id="el" class="preloader-wrapper big active">
        <div class="spinner-layer spinner-blue-only">
          <div class="circle-clipper left">
            <div class="circle"></div>
          </div>
          <div class="gap-patch">
            <div class="circle"></div>
          </div>
          <div class="circle-clipper right">
            <div class="circle"></div>
          </div>
        </div>
      </div>
      <label style="font-size:25px">Uploading file... {{uploadPercentage}}%</label>
    </div>
    <!-- Display image and delete button after upload -->
    <div class="float: left">
      <div>
        <img :src="downloadURL" width="100%" style="max-height: 250px; max-width: 250px;">
        <!-- Wrapper to use custom upload button -->
        <div v-if="!uploadEnd && !uploading" class="upload-btn-wrapper">
          <a
            class="waves-effect waves-light btn green"
            onclick="document.getElementById('fileButton').click()"
          >
            <i class="material-icons left">add</i>Upload image
          </a>
          <input type="file" value="uplaod" id="fileButton" @change="upload">
        </div>
      </div>
      <div class="center">
        <a v-if="uploadEnd" class="waves-effect waves-light btn red" @click="deleteImage()">delete</a>
      </div>
    </div>
  </div>
</template>

<script>
import db from "../firebaseInit";
import firebase from "firebase/app";
import "firebase/storage";

export default {
  name: "imageUploader",
  // prop can be supllied to display an image already stored
  props: ["imageURL"],
  data() {
    return {
      selectedFile: null,
      uploadPercentage: 0,
      uploading: false,
      uploadEnd: false,
      uploadTask: "",
      fileName: "",
      downloadURL: ""
    };
  },
  methods: {
    // called when a file has been selected from the file picker
    // checks that the file is of an acceptable format before attempting to upload
    upload(event) {
      this.selectedFile = event.target.files[0];
      this.fileName = this.selectedFile.name;
      let fileExtension = this.fileName
        .split(".")
        [this.fileName.split(".").length - 1].toLowerCase();
      let fileSize = this.selectedFile.size;
      let mbSize = (fileSize / 1048576).toFixed(2);

      // check the file for format and size
      if (
        !(
          fileExtension === "jpg" ||
          fileExtension === "jpeg" ||
          fileExtension === "png" ||
          fileExtension === "gif"
        ) ||
        fileSize > 1048576
      ) {
        let txt = "File type : " + fileExtension + "\n\n";
        txt += "Size: " + mbSize + " MB \n\n";
        txt +=
          "Please make sure your file is in jpg, jpeg, png or gif format and less than 1 MB.\n\n";
        alert(txt);
      } else {
        // upload the image to firebase storage
        this.uploading = true;
        this.uploadTask = firebase
          .storage()
          .ref("images/" + this.fileName)
          .put(this.selectedFile);
      }
    },
    deleteImage() {
      // remove the currently displayed image from firebase and rest the component ready for a new picture
      firebase
        .storage()
        .refFromURL(this.downloadURL)
        .delete()
        .then(() => {
          this.uploading = false;
          this.uploadEnd = false;
          this.uploadPercentage = 0;
          this.downloadURL = "";
        })
        .catch(error => {
          console.error(`file delete error occured: ${error}`);
        });
    }
  },
  watch: {
    // function is triggered when a file starts uploading to firestore
    // progress is tracked in the uploadPercentage property
    uploadTask: function() {
      this.uploadTask.on(
        "state_changed",
        snapshot => {
          var progress =
            (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
          this.uploadPercentage = progress;
        },

        error => {
          console.error(`file upload error occured: ${error}`);
        },
        // upload is complete and download URL is stored and emited to parent components
        () => {
          this.uploadTask.snapshot.ref.getDownloadURL().then(downloadURL => {
            this.uploadEnd = true;
            this.downloadURL = downloadURL;
            this.$emit("downloadURL", downloadURL);
          });
        }
      );
    },
    // if provided with an image component at creation, this will ensure that the image is displayed
    // and the delete button rather than the upload button
    imageURL: function() {
      if (this.imageURL !== null && this.imageURL !== "") {
        this.uploadEnd = true;
        this.downloadURL = this.imageURL;
      }
    }
  }
};
</script>

<style scoped>
.upload-btn-wrapper {
  position: relative;
  overflow: hidden;
  display: inline-block;
  cursor: pointer;
}

.upload-btn-wrapper input[type="file"] {
  font-size: 100px;
  position: absolute;
  left: 0;
  top: 0;
  opacity: 0;
  cursor: pointer;
}
</style>
