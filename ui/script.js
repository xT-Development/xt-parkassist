window.addEventListener('message', (event) => {
    const data = event.data;
    switch (data.action) {
        case 'updateDistance':
            const { dist, maxDist } = event.data;
            const pct = Math.min(Math.max(1 - dist / maxDist, 0), 1);
            const barFill = document.getElementById('main-fill');
            const barText = document.getElementById('main-text');

            const display = dist >= maxDist ? '> ' + maxDist.toFixed(1) : dist.toFixed(1);
            barText.textContent = display + ' m';

            barFill.style.width = (pct * 100) + '%';

            if (pct > 0.001) {
                barFill.style.backgroundSize = (100 / pct) + '% 100%';
            } else {
                barFill.style.backgroundSize = '0% 100%';
            }

            break;

        case 'toggleDistanceUI':
            const container = document.getElementById('main-container');
            container.style.display = data.visible ? 'flex' : 'none';
            break;
    }
});