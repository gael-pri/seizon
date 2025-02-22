import type React from "react";
import { useRef, useState } from "react";
import { cn } from "../../../lib/utils";

interface FileUploaderProps {
  state?: "default" | "hover" | "uploading" | "failed" | "complete" | "disabled";
  onFileSelect?: (file: File) => void;
  accept?: string;
  maxSize?: number;
  section?: string;
  displayName?: string;
  description?: string;
  thumbnailUrl?: string;
  importPath: string;
}

const FileUploader = ({
  state = "default",
  onFileSelect,
  accept = "*/*",
  maxSize = 5242880, // 5MB
}: FileUploaderProps) => {
  const [dragActive, setDragActive] = useState(false);
  const inputRef = useRef<HTMLInputElement>(null);

  const handleDrag = (e: React.DragEvent) => {
    e.preventDefault();
    e.stopPropagation();
    if (e.type === "dragenter" || e.type === "dragover") {
      setDragActive(true);
    } else if (e.type === "dragleave") {
      setDragActive(false);
    }
  };

  const handleDrop = (e: React.DragEvent) => {
    e.preventDefault();
    e.stopPropagation();
    setDragActive(false);
    if (e.dataTransfer.files && e.dataTransfer.files[0]) {
      handleFiles(e.dataTransfer.files[0]);
    }
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    e.preventDefault();
    if (e.target.files && e.target.files[0]) {
      handleFiles(e.target.files[0]);
    }
  };

  const handleFiles = (file: File) => {
    if (file.size > maxSize) {
      alert("File is too large");
      return;
    }
    onFileSelect?.(file);
  };

  const getStateStyles = () => {
    switch (state) {
      case "uploading":
        return "border-blue-400 bg-blue-50";
      case "complete":
        return "border-green-400 bg-green-50";
      case "failed":
        return "border-red-400 bg-red-50";
      case "disabled":
        return "border-gray-200 bg-gray-50 opacity-50 cursor-not-allowed";
      default:
        return dragActive
          ? "border-blue-400 bg-blue-50"
          : "border-gray-300 hover:border-gray-400";
    }
  };

  return (
    <div
      className={cn(
        "relative p-6 border-2 border-dashed rounded-lg transition-colors",
        getStateStyles()
      )}
      onDragEnter={handleDrag}
      onDragLeave={handleDrag}
      onDragOver={handleDrag}
      onDrop={handleDrop}
    >
      <input
        ref={inputRef}
        type="file"
        className="hidden"
        onChange={handleChange}
        accept={accept}
        disabled={state === "disabled"}
      />
      
      <div className="text-center">
        {state === "uploading" && (
          <div className="mb-2">
            <div className="w-full bg-blue-200 rounded-full h-2.5">
              <div className="bg-blue-600 h-2.5 rounded-full w-1/2"></div>
            </div>
          </div>
        )}
        
        <button
          type="button"
          onClick={() => inputRef.current?.click()}
          disabled={state === "disabled"}
          className={cn(
            "text-sm font-medium",
            state === "disabled" ? "text-gray-400" : "text-blue-600"
          )}
        >
          Click to upload
        </button>
        <span className="text-sm text-gray-500"> or drag and drop</span>
      </div>
    </div>
  );
};

export {FileUploader};