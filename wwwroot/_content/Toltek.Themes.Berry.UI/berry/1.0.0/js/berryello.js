// Dinamik içerik gösterme işlevi
document.querySelector('.dynamic-select').addEventListener('change', function () {
    var selectedValue = this.value;

    // Tüm içerikleri gizle
    document.querySelectorAll('.content').forEach(function (content) {
        content.style.display = 'none';
    });

    // Seçilen içeriği göster
    document.getElementById(selectedValue).style.display = 'block';
});

document.addEventListener('DOMContentLoaded', function () {
    tinymce.init({
        selector: 'textarea.tinymce-editor',  // Editör uygulanacak textarea
        plugins: 'lists link image table code', // Kullanmak istediğiniz eklentiler
        toolbar: 'undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image', // Araç çubuğu ayarları
        menubar: false, // Menü çubuğu göstermek istemezseniz false yapabilirsiniz
        height: 300 // Yükseklik ayarı
    });
});

const uppy = Uppy.Core()
    .use(Uppy.Dashboard, {
        inline: true,
        target: '#uppy',
        height: 400,
        width: 600,
        note: 'Dosyalarınızı buraya sürükleyebilir veya yüklemek için tıklayabilirsiniz.'
    })
    .use(Uppy.XHRUpload, {
        endpoint: '/upload', // Yükleme uç noktası
        formData: true,
        fieldName: 'files[]'
    });

