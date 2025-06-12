// Main JavaScript file for Social Media Fetcher

// Global utilities
window.utils = {
    // Format numbers with K/M suffixes
    formatNumber(num) {
        if (!num) return '0';
        if (num >= 1000000) {
            return (num / 1000000).toFixed(1) + 'M';
        } else if (num >= 1000) {
            return (num / 1000).toFixed(1) + 'K';
        }
        return num.toString();
    },

    // Format dates relative to now
    formatRelativeDate(dateString) {
        if (!dateString) return 'Unknown';
        
        const date = new Date(dateString);
        const now = new Date();
        const diffTime = Math.abs(now - date);
        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
        const diffHours = Math.ceil(diffTime / (1000 * 60 * 60));
        const diffMinutes = Math.ceil(diffTime / (1000 * 60));

        if (diffMinutes < 60) {
            return `${diffMinutes} minutes ago`;
        } else if (diffHours < 24) {
            return `${diffHours} hours ago`;
        } else if (diffDays === 1) {
            return 'Yesterday';
        } else if (diffDays < 7) {
            return `${diffDays} days ago`;
        } else {
            return date.toLocaleDateString();
        }
    },

    // Format absolute dates
    formatDate(dateString) {
        if (!dateString) return 'Unknown';
        const date = new Date(dateString);
        return date.toLocaleDateString() + ' ' + date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
    },

    // Truncate text with ellipsis
    truncateText(text, maxLength = 100) {
        if (!text || text.length <= maxLength) return text;
        return text.substring(0, maxLength) + '...';
    },

    // Copy text to clipboard
    async copyToClipboard(text) {
        try {
            await navigator.clipboard.writeText(text);
            return true;
        } catch (error) {
            console.error('Failed to copy to clipboard:', error);
            return false;
        }
    },

    // Show toast notification
    showToast(message, type = 'info', duration = 3000) {
        const toast = document.createElement('div');
        toast.className = `rounded-md p-4 mb-2 shadow-lg transform transition-all duration-300 ease-in-out ${
            type === 'success' ? 'bg-green-50 text-green-800 border border-green-200' :
            type === 'error' ? 'bg-red-50 text-red-800 border border-red-200' :
            type === 'warning' ? 'bg-yellow-50 text-yellow-800 border border-yellow-200' :
            'bg-blue-50 text-blue-800 border border-blue-200'
        }`;
        
        toast.innerHTML = `
            <div class="flex items-start">
                <div class="flex-shrink-0">
                    <i class="fas ${
                        type === 'success' ? 'fa-check-circle' :
                        type === 'error' ? 'fa-exclamation-circle' :
                        type === 'warning' ? 'fa-exclamation-triangle' :
                        'fa-info-circle'
                    } h-5 w-5"></i>
                </div>
                <div class="ml-3 flex-1">
                    <p class="text-sm font-medium">${message}</p>
                </div>
                <div class="ml-4 flex-shrink-0">
                    <button onclick="this.parentElement.parentElement.parentElement.remove()" 
                            class="inline-flex text-gray-400 hover:text-gray-600 focus:outline-none">
                        <i class="fas fa-times h-4 w-4"></i>
                    </button>
                </div>
            </div>
        `;
        
        // Add slide-in animation
        toast.style.transform = 'translateX(100%)';
        toast.style.opacity = '0';
        
        const container = document.getElementById('toast-container');
        if (container) {
            container.appendChild(toast);
            
            // Trigger animation
            setTimeout(() => {
                toast.style.transform = 'translateX(0)';
                toast.style.opacity = '1';
            }, 10);
            
            // Auto-remove after duration
            setTimeout(() => {
                toast.style.transform = 'translateX(100%)';
                toast.style.opacity = '0';
                setTimeout(() => {
                    if (toast.parentNode) {
                        toast.remove();
                    }
                }, 300);
            }, duration);
        }
    },

    // Debounce function for search inputs
    debounce(func, wait) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    },

    // Validate URLs
    isValidUrl(string) {
        try {
            new URL(string);
            return true;
        } catch (_) {
            return false;
        }
    },

    // Get source icon class
    getSourceIcon(sourceType) {
        const icons = {
            telegram: 'fab fa-telegram',
            vk: 'fab fa-vk',
            twitter: 'fab fa-twitter',
            facebook: 'fab fa-facebook',
            instagram: 'fab fa-instagram',
            youtube: 'fab fa-youtube'
        };
        return icons[sourceType] || 'fas fa-rss';
    },

    // Get source color class
    getSourceColor(sourceType) {
        const colors = {
            telegram: 'text-blue-600',
            vk: 'text-indigo-600',
            twitter: 'text-blue-400',
            facebook: 'text-blue-700',
            instagram: 'text-pink-600',
            youtube: 'text-red-600'
        };
        return colors[sourceType] || 'text-gray-600';
    },

    // Get source background class
    getSourceBg(sourceType) {
        const backgrounds = {
            telegram: 'bg-blue-100',
            vk: 'bg-indigo-100',
            twitter: 'bg-blue-50',
            facebook: 'bg-blue-100',
            instagram: 'bg-pink-100',
            youtube: 'bg-red-100'
        };
        return backgrounds[sourceType] || 'bg-gray-100';
    }
};

// Global API helper
window.api = {
    baseUrl: '/api',

    async request(endpoint, options = {}) {
        const url = `${this.baseUrl}${endpoint}`;
        const config = {
            headers: {
                'Content-Type': 'application/json',
                ...options.headers
            },
            ...options
        };

        try {
            const response = await fetch(url, config);
            
            if (!response.ok) {
                const error = await response.json().catch(() => ({ detail: 'Unknown error' }));
                throw new Error(error.detail || `HTTP ${response.status}`);
            }
            
            return await response.json();
        } catch (error) {
            console.error(`API Error (${endpoint}):`, error);
            throw error;
        }
    },

    // Convenience methods
    get(endpoint) {
        return this.request(endpoint, { method: 'GET' });
    },

    post(endpoint, data) {
        return this.request(endpoint, {
            method: 'POST',
            body: JSON.stringify(data)
        });
    },

    put(endpoint, data) {
        return this.request(endpoint, {
            method: 'PUT',
            body: JSON.stringify(data)
        });
    },

    delete(endpoint) {
        return this.request(endpoint, { method: 'DELETE' });
    }
};

// Initialize global features when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    // Add loading states to buttons
    document.addEventListener('click', function(e) {
        const button = e.target.closest('button');
        if (button && button.type === 'submit') {
            const spinner = button.querySelector('.fas.fa-spinner');
            if (spinner) {
                spinner.classList.add('animate-spin');
            }
        }
    });

    // Add smooth scrolling to anchor links
    document.addEventListener('click', function(e) {
        const link = e.target.closest('a[href^="#"]');
        if (link) {
            e.preventDefault();
            const target = document.querySelector(link.getAttribute('href'));
            if (target) {
                target.scrollIntoView({ behavior: 'smooth' });
            }
        }
    });

    // Add keyboard shortcuts
    document.addEventListener('keydown', function(e) {
        // Ctrl/Cmd + R: Refresh current page data
        if ((e.ctrlKey || e.metaKey) && e.key === 'r') {
            e.preventDefault();
            const refreshButton = document.querySelector('button[onclick*="refresh"], button[x-on\\:click*="refresh"]');
            if (refreshButton) {
                refreshButton.click();
            }
        }

        // Escape: Close modals
        if (e.key === 'Escape') {
            const modals = document.querySelectorAll('[x-show*="Modal"], [x-show*="modal"]');
            modals.forEach(modal => {
                if (modal.style.display !== 'none') {
                    const closeButton = modal.querySelector('button[x-on\\:click*="false"], button[onclick*="close"]');
                    if (closeButton) {
                        closeButton.click();
                    }
                }
            });
        }
    });

    // Add auto-refresh for certain pages
    const autoRefreshPages = ['dashboard', 'analytics'];
    const currentPage = window.location.pathname.split('/').pop() || 'dashboard';
    
    if (autoRefreshPages.includes(currentPage)) {
        // Refresh every 5 minutes
        setInterval(() => {
            const refreshButton = document.querySelector('button[onclick*="refresh"], button[x-on\\:click*="refresh"]');
            if (refreshButton && document.visibilityState === 'visible') {
                refreshButton.click();
            }
        }, 5 * 60 * 1000);
    }

    // Add offline/online status detection
    function updateOnlineStatus() {
        const statusIndicator = document.getElementById('status-indicator');
        const statusText = document.getElementById('status-text');
        
        if (statusIndicator && statusText) {
            if (navigator.onLine) {
                statusIndicator.className = 'h-2 w-2 bg-green-400 rounded-full';
                statusText.textContent = 'Connected';
            } else {
                statusIndicator.className = 'h-2 w-2 bg-red-400 rounded-full';
                statusText.textContent = 'Offline';
            }
        }
    }

    window.addEventListener('online', updateOnlineStatus);
    window.addEventListener('offline', updateOnlineStatus);
    updateOnlineStatus();
});

// Export utilities for use in Alpine.js components
window.formatNumber = window.utils.formatNumber;
window.formatDate = window.utils.formatDate;
window.formatRelativeDate = window.utils.formatRelativeDate;
window.showToast = window.utils.showToast;
window.copyToClipboard = window.utils.copyToClipboard; 