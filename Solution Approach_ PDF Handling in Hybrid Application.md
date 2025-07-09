## **Solution Approach: PDF Handling in Hybrid Application**

This document outlines two distinct approaches to resolve the issue of rendering authenticated PDF documents initiated from a third-party web application within a Cordova hybrid app.

---

### **Option 1: Native Handling via Cordova Interception**

This approach uses the Cordova application as a mediator to handle the PDF download and pass it to the native operating system for rendering. The third-party web application requires **no modifications**.

#### **Workflow:**

1. **Intercept Request**: The main Cordova app launches the third-party site in an InAppBrowser and uses a beforeload event listener to intercept navigation to any URL ending in .pdf.  
2. **Execute Script in Context**: Upon interception, the main app injects a script into the InAppBrowser using the executeScript method. This script fetches the PDF using the third-party site's existing authentication cookies and returns the document's content as a Base64 string.  
3. **Receive Data**: The main app receives the Base64 data from the executeScript callback.  
4. **Save and Open Natively**: The main app uses the cordova-plugin-file to save the PDF to the device's local storage and then uses the cordova-plugin-file-opener2 to open it with a native PDF viewer application.

#### **Dependencies:**

* **Main Cordova App:**  
  * cordova-plugin-inappbrowser  
  * cordova-plugin-file  
  * cordova-plugin-file-opener2

#### **Pros & Cons:**

* ✅ **Pro:** Leverages powerful and high-performance native PDF viewers.  
* ✅ **Pro:** Requires no changes to the third-party application.  
* ❌ **Con:** User experience involves temporarily leaving the app to view the file.  
* ❌ **Con:** Increases the complexity of the main Cordova application's code.

#### **Code Snippets:**

**main-app.js (Main Cordova App Logic)**

JavaScript

// 1\. Open the InAppBrowser with 'beforeload' enabled  
const browser \= cordova.InAppBrowser.open('https://third-party-site.com', '\_blank', 'location=yes,beforeload=yes');

// 2\. Add the event listener to intercept PDF requests  
browser.addEventListener('beforeload', (params, callback) \=\> {  
    if (params.url.endsWith('.pdf')) {  
        console.log('PDF URL intercepted:', params.url);

        // Inject a script to fetch the PDF as Base64 from within the InAppBrowser  
        browser.executeScript({  
            code: \`  
                (function() {  
                    return fetch('${params.url}')  
                        .then(response \=\> response.blob())  
                        .then(blob \=\> {  
                            return new Promise((resolve, reject) \=\> {  
                                const reader \= new FileReader();  
                                reader.onloadend \= () \=\> resolve(reader.result); // Returns "data:application/pdf;base64,..."  
                                reader.onerror \= reject;  
                                reader.readAsDataURL(blob);  
                            });  
                        });  
                })();  
            \`  
        }, (results) \=\> {  
            // This callback receives the Base64 data in the main app  
            if (results && results\[0\]) {  
                saveAndOpenBase64Pdf(results\[0\], 'document.pdf');  
            }  
        });

    } else {  
        // Not a PDF, so let the InAppBrowser load the URL normally  
        callback(params.url);  
    }  
});

/\*\*  
 \* Decodes a Base64 string into a Blob, saves it, and opens it.  
 \* @param {string} base64Data \- The "data:application/pdf;base64,..." string.  
 \* @param {string} fileName \- The name for the saved file.  
 \*/  
function saveAndOpenBase64Pdf(base64Data, fileName) {  
    const filePath \= cordova.file.dataDirectory;

    // Convert Base64 to Blob  
    fetch(base64Data)  
        .then(res \=\> res.blob())  
        .then(blob \=\> {  
            window.resolveLocalFileSystemURL(filePath, (dirEntry) \=\> {  
                dirEntry.getFile(fileName, { create: true, exclusive: false }, (fileEntry) \=\> {  
                    fileEntry.createWriter((fileWriter) \=\> {  
                        fileWriter.onwriteend \= () \=\> {  
                            // Open the saved local file with a native PDF viewer  
                            cordova.plugins.fileOpener2.open(  
                                fileEntry.toURL(),  
                                'application/pdf',  
                                { error: (e) \=\> console.error('Error opening file:', e.message) }  
                            );  
                        };  
                        fileWriter.onerror \= (e) \=\> console.error('File write error:', e.toString());  
                        fileWriter.write(blob);  
                    });  
                });  
            });  
        })  
        .catch(err \=\> console.error('Error in blob conversion:', err));  
}

---

### **Option 2: In-App Rendering by Third-Party App**

This approach embeds the PDF rendering logic directly into the third-party web application, requiring **no special logic** in the main Cordova app.

#### **Workflow:**

1. **Modify Third-Party App**: The third-party web application is modified to include the PDF.js library.  
2. **Internal Fetch and Render**: When a user requests a PDF, the third-party app's own JavaScript intercepts the action. It fetches the PDF data internally using its authenticated session.  
3. **Render In-Page**: The app then uses PDF.js to render the fetched PDF data directly into a \<canvas\> element on the current page. The Cordova app simply displays this web content without any special handling.

#### **Dependencies:**

* **Third-Party Web App:**  
  * [PDF.js](https://mozilla.github.io/pdf.js/) library from Mozilla.

#### **Pros & Cons:**

* ✅ **Pro:** Provides a seamless user experience, as the user never leaves the application window.  
* ✅ **Pro:** Drastically simplifies the Cordova application's logic.  
* ❌ **Con:** Requires modification and maintenance of the third-party web application's code.  
* ❌ **Con:** Performance for large or complex PDFs may be slower than a native viewer.

#### **Code Snippets:**

**third-party-app.js (Third-Party Web App Logic)**

JavaScript

// Include PDF.js library in the HTML:  
// \<script src="https://mozilla.github.io/pdf.js/build/pdf.js"\>\</script\>

// Set the worker source path  
pdfjsLib.GlobalWorkerOptions.workerSrc \= 'https://mozilla.github.io/pdf.js/build/pdf.worker.js';

// Get the button/link that triggers the PDF download  
const pdfButton \= document.getElementById('viewPdfButton');

pdfButton.addEventListener('click', (event) \=\> {  
    event.preventDefault();  
    const pdfUrl \= event.target.href; // The URL to the authenticated PDF

    // Show a container for the PDF viewer  
    const viewerContainer \= document.getElementById('pdf-viewer');  
    viewerContainer.style.display \= 'block';

    // Fetch the PDF with authentication cookies and render it  
    const loadingTask \= pdfjsLib.getDocument(pdfUrl);  
    loadingTask.promise.then(function(pdf) {  
        // Fetch the first page  
        pdf.getPage(1).then(function(page) {  
            const scale \= 1.5;  
            const viewport \= page.getViewport({ scale: scale });

            // Prepare canvas using PDF page dimensions  
            const canvas \= document.getElementById('pdf-canvas');  
            const context \= canvas.getContext('2d');  
            canvas.height \= viewport.height;  
            canvas.width \= viewport.width;

            // Render PDF page into canvas context  
            const renderContext \= {  
                canvasContext: context,  
                viewport: viewport  
            };  
            page.render(renderContext);  
        });  
    }, function (reason) {  
        console.error(reason);  
    });  
});

**third-party-app.html (Relevant HTML Structure)**

HTML

\<a href\="/generate-authenticated-pdf" id\="viewPdfButton"\>View PDF Summary\</a\>

\<div id\="pdf-viewer" style\="display:none;"\>  
    \<canvas id\="pdf-canvas"\>\</canvas\>  
\</div\>