import React from "react";

const ImageViewer = ({
  show = false,
  imageSrc = "",
  type = "photo",
  onClose = () => {},
  onNext = () => {},
  onPrev = () => {},
  date = "",
  deletePhoto = () => {},
  share = () => {},
}) => {
  return (
    <div className={`image-viewer-overlay ${show ? "show" : ""}`} onClick={onClose}>
      <div className="image-viewer" onClick={(e) => e.stopPropagation()}>
        <button className="viewer-close" onClick={onClose}>
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none">
            <mask id="mask0_4227_59" style={{ maskType: "alpha" }} maskUnits="userSpaceOnUse" x="0" y="0" width="24" height="24">
              <rect width="24" height="24" fill="#D9D9D9" />
            </mask>
            <g mask="url(#mask0_4227_59)">
              <path d="M6.4 19L5 17.6L10.6 12L5 6.4L6.4 5L12 10.6L17.6 5L19 6.4L13.4 12L19 17.6L17.6 19L12 13.4L6.4 19Z" fill="#EBEBEB" />
            </g>
          </svg>
        </button>

        <button className="viewer-prev" onClick={onPrev}>
          <svg xmlns="http://www.w3.org/2000/svg" width="12" height="20" viewBox="0 0 12 20" fill="none">
            <path d="M10 20L0 10L10 0L11.775 1.775L3.55 10L11.775 18.225L10 20Z" fill="#D9D9D9" />
          </svg>
        </button>

        <span className="date-gallerymedia">{date}</span>

        {type === "photo" && imageSrc ? (
          <img src={imageSrc} alt="Preview" className="viewer-image" />
        ) : type === "video" && imageSrc ? (
          <video controls className="viewer-video">
            <source src={imageSrc} type="video/mp4" />
            Tarayıcınız bu videoyu desteklemiyor.
          </video>
        ) : (
          <div className="viewer-error">Medya yüklenemedi</div>
        )}

        <div
          style={{
            display: "flex",
            justifyContent: "center",
            position: "absolute",
            height: "2.8rem",
            background: "#00000059",
            alignItems: "center",
            width: "100%",
            bottom: "0rem",
            gap: "19px",
          }}
        >
          <div onClick={deletePhoto} className="delete-photo-b">
            <i className="fa-solid fa-trash"></i>
          </div>
          <div onClick={share} className="delete-photo-b">
            <i className="fa-solid fa-share"></i>
          </div>
        </div>

        <button className="viewer-next" onClick={onNext}>
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none">
            <mask id="mask0_4227_31" style={{ maskType: "alpha" }} maskUnits="userSpaceOnUse" x="0" y="0" width="24" height="24">
              <rect width="24" height="24" fill="#D9D9D9" />
            </mask>
            <g mask="url(#mask0_4227_31)">
              <path d="M8.025 22L6.25 20.225L14.475 12L6.25 3.775L8.025 2L18.025 12L8.025 22Z" fill="#EEEEEE" />
            </g>
          </svg>
        </button>
      </div>
    </div>
  );
};

export default ImageViewer;
