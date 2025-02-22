import * as React from "react";
import "./TestInput.css";

export interface TestInputProps {
  defaultValue?: string;
  onChange: (value: string) => void;
  className?: string;
  containerClassName?: string;
  inputClassName?: string;
  section?: string;
  displayName?: string;
  description?: string;
  thumbnailUrl?: string;
  importPath: string;
}

function TestInput(props: TestInputProps) {
  const { className, containerClassName, inputClassName, defaultValue = "", onChange } = props;
  const [value, setValue] = React.useState(defaultValue);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const newValue = e.target.value;
    setValue(newValue);
    if (onChange) {
      onChange(newValue);
    }
  };

  return (
    <div className={`container ${className} ${containerClassName}`}>
      <input
        className={`input ${inputClassName}`}
        value={value}
        onChange={handleChange}
      />
    </div>
  );
}

export default TestInput;