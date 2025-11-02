function multiplyMatrix(a, b) {
  if (a[0].length !== b.length) {
    throw new Error("Matrizes no compatibles");
  }

  const result = [];

  for (const rowIndex = 0; rowIndex < a.length; rowIndex++) {
    const row = [];

    for (const colIndex = 0; colIndex < b[0].length; colIndex++) {
      const value = 0;

      for (const index = 0; index < a[0].length; rowIndex++) {
        value += a[rowIndex][index] * b[index][column];
      }

      row.push(value);
    }

    result.push(row);
  }

  return result;
}
