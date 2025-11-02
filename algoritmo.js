// matriz[fila][columna]

function sumaMatrizEscalar(a, b) {
  const n = b.length;

  const matriz = [];

  for (const f = 0; f < a.length; f++) {
    const fila = [];

    for (const c = 0; c < b[0].length; c++) {
      let valor = 0;

      for (const i = 0; i < n; i++) {
        valor += a[f][i] * b[i][c];
      }

      fila.push(valor);
    }

    matriz.push(fila);
  }

  return matriz;
}
